@import "../util/AwakeningObject.j"
@import "../util/Time.j"

@implementation ReservationDataControllerPMR : AwakeningObject
{
  CPTextField courseField;
  CPTextField instructorField;
  CPTextField dateField;
  TimeControl timeControl;

  CPButton beginButton;
  CPButton reserveButton;
  CPButton restartButton;

  CPView previousResultsView;
  CPWebView linkToPreviousResults;
  CPButton copyButton;

  CPView dateGatheringView;
  CPView dateDisplayingView;
  CPTextField dateTimeSummary;

  PanelController dateTimeEditingPanelController;
  DateTimeEditingControl dateTimeEditingControl;
}

- (void) beginReserving: sender
{
  [self sendNotification: ReservationDataAvailable
               aboutDate: [dateField stringValue]
                 andTime: [timeControl time]];
};

- (void) prepareToFinishReservation
{
  [self noteTimeAndDate];
  [self showDateAndTimeFields: NO];
  [self showGroupEditButtons: YES];
  [previousResultsView setHidden: YES];
}

- (void) makeReservation: sender
{
  [NotificationCenter postNotificationName: TimeToReserveNews object: nil];
}


- (id) offerOperationsOnJustFinishedReservation: reservationID
{
  var href = "/reservation/" + reservationID;
  var message = "Click to view the reservation in a new window.";
  [linkToPreviousResults loadHTMLString:@"<a href='" + href + "' target=\"_blank\">" + message + "</a>"
               baseURL: nil];
  [copyButton setTag: reservationID];
  [previousResultsView setHidden: NO];
}

- (void) beginningOfReservationWorkflow
{
  [self showDateAndTimeFields: YES];
  [self showGroupEditButtons: NO];
}

- (void) abandonReservation:sender
{
  alert("This isn't implemented yet. You can achieve the same effect by reloading this page in your browser.");
}

- (void) setNewValuesFrom: dictionary
{
  [courseField setStringValue: [dictionary valueForKey: 'course']];
  [instructorField setStringValue: [dictionary valueForKey: 'instructor']];
  [dateField setStringValue: [dictionary valueForKey: 'date']];
  [timeControl setTime: [dictionary valueForKey: 'time']];
  [self noteTimeAndDate];
}

- (void) startDestructivelyEditingDateTime: sender
{
  [dateTimeEditingPanelController appear];
  [dateTimeEditingControl setDate: [dateField stringValue]
                             time: [timeControl time]];
}

- (void) forgetEditingDateTime: sender
{
  [dateTimeEditingPanelController disappear];
}


- (void) newDateTimeValuesReady: sender
{
  [dateTimeEditingPanelController disappear];
  var date = [dateTimeEditingControl date];
  var time = [dateTimeEditingControl time];
  [dateField setStringValue: date];
  [timeControl setTime: time];
  [self noteTimeAndDate];

  [self sendNotification: DateTimeForCurrentReservationChangedNews
               aboutDate: date
                 andTime: time];
}

- (void) copyPreviousReservation: sender
{
  var id = [copyButton tag];
  [NotificationCenter postNotificationName: CopyReservationNews object: id];
}


// Util

- (void) showGroupEditButtons: value
{
  [restartButton setHidden: !value];
  [reserveButton setHidden: !value];
}

- (void) showDateAndTimeFields: value
{
  [dateGatheringView setHidden: !value];
  [dateDisplayingView setHidden: value];
}

- (void) noteTimeAndDate
{
  var note = "on the " + [[timeControl time] description] + 
    " of " + [dateField stringValue] + ".";
  [dateTimeSummary setStringValue: note];
}

-(void) sendNotification: name aboutDate: date andTime: time
{
  var data = [CPDictionary dictionary];
  [data setValue: date forKey: 'date'];
  [data setValue: time forKey: 'time'];
  
  [NotificationCenter postNotificationName: name object: data];
}

- (CPDictionary) data
{
  var dict = [CPDictionary dictionary];
  [dict setValue: [courseField stringValue] forKey: 'course'];
  [dict setValue: [instructorField stringValue] forKey: 'instructor'];
  [dict setValue: [dateField stringValue] forKey: 'date'];
  [dict setValue: [timeControl time] forKey: 'time'];
  return dict;
}

@end


