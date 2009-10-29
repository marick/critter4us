@import "../util/AwakeningObject.j"
@import "../util/Time.j"



@implementation ReservationDataControllerPMR : AwakeningObject
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

  PanelController dateTimeEditingPanelController;
  DateTimeEditingControl dateTimeEditingControl;
}

- (void) beginReserving: sender
{
  [self sendNotification: ReservationDataAvailable
               aboutDate: [dateField stringValue]
                 andTime: [self timeFromState: [morningButton state]]];
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

- (void) startDestructivelyEditingDateTime: sender
{
  [dateTimeEditingPanelController appear];
  [dateTimeEditingControl setDate: [dateField stringValue]
                     morningState: [morningButton state]];
}

- (void) forgetEditingDateTime: sender
{
  [dateTimeEditingPanelController disappear];
}


- (void) newDateTimeValuesReady: sender
{
  [dateTimeEditingPanelController disappear];
  var date = [dateTimeEditingControl date];
  var state = [dateTimeEditingControl morningState]
  [dateField setStringValue: date];
  [morningButton setState: state];

  [self sendNotification: DateTimeForCurrentReservationChangedNews
               aboutDate: date
                 andTime: [self timeFromState: state]];

  [self noteTimeAndDate];
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
  return [self timeFromState: [morningButton state]]
}

-(Time) timeFromState: state
{
  return (state == CPOnState) ? [Time morning] : [Time afternoon];
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
  [dict setValue: [self deduceTime] forKey: 'time'];
  return dict;
}

@end


