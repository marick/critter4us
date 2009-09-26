@import "../util/AwakeningObject.j"
@import "../util/Time.j"

@implementation ReservationDataControllerPMR : PanelController
{
  CPTextField courseField;
  CPTextField instructorField;
  CPTextField dateField;
  CPRadio morningButton;
  CPRadio afternoonButton;

  CPButton beginButton;
  CPButton reserveButton;
  CPButton restartButton;

  CPWebView linkToPreviousResults;

  CPView dateGatheringView;
  CPView dateDisplayingView;
  CPTextField dateTimeSummary;
  CPButton dateTimeButton;
}

- (void) beginReserving: sender
{
  var data = [CPDictionary dictionary];
  [data setValue: [dateField stringValue] forKey: 'date'];
  time = ([morningButton state] == CPOnState) ? [Time morning] : [Time afternoon];
  [data setValue: time forKey: 'time'];

  [NotificationCenter postNotificationName: ReservationDataAvailable
                                    object: data];
}

- (void) prepareToFinishReservation
{
  [self noteTimeAndDate];
  [self showDateAndTimeFields: NO];
  [self showGroupEditButtons: YES];
  [linkToPreviousResults setHidden: YES];
}

- (void) makeReservation: sender
{
  [NotificationCenter postNotificationName: TimeToReserveNews object: nil];
}

- (id) spillIt: (CPMutableDictionary) dict
{
  [dict setValue: [courseField stringValue] forKey: 'course'];
  [dict setValue: [instructorField stringValue] forKey: 'instructor'];
  [dict setValue: [dateField stringValue] forKey: 'date'];
  [dict setValue: [self deduceTime] forKey: 'time'];
}

- (id) offerReservationView: reservationID
{
  var href = "/reservation/" + reservationID;
  var message = "Click to view the reservation in a new window.";
  [linkToPreviousResults loadHTMLString:@"<a href='" + href + "' target=\"_blank\">" + message + "</a>"
               baseURL: nil];
  [linkToPreviousResults setHidden: NO];
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

- (void) edit: dictionary
{
  [courseField setStringValue: [dictionary valueForKey: 'course']];
  [instructorField setStringValue: [dictionary valueForKey: 'instructor']];
  [dateField setStringValue: [dictionary valueForKey: 'date']];
  var isMorning = [[dictionary valueForKey: 'time'] isEqual: [Time morning]];
  var state =  isMorning ? CPOnState : CPOffState;
  [morningButton setState: state];
}

- (void) changeDateTime: sender
{
  alert("Not implemented");
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
  var note = "on the " + [[self deduceTime] description] + 
    " of " + [dateField stringValue] + ".";
  [dateTimeSummary setStringValue: note];
}

- (id) deduceTime
{
  if ([morningButton state] == CPOnState) 
    return [Time morning];
  else
    return [Time afternoon];
}

@end


