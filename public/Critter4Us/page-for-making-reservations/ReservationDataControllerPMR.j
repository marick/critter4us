@import "../util/AwakeningObject.j"
@import "../util/Timeslice.j"
@import "../view/TimesliceSummary.j"
@import "../view/TimesliceControl.j"


// This controller does way too many things!

@implementation ReservationDataControllerPMR : AwakeningObject
{
  CPTextField courseField;
  CPTextField instructorField;

  TimesliceControl timesliceControl;
  TimesliceSummary timesliceSummary;

  CPButton beginButton;
  CPButton reserveButton;

  CPView previousResultsView;
  CPWebView linkToPreviousResults;
  CPButton copyButton;

  CPView dateGatheringView;
  CPView majorModificationView;

  PanelController timesliceChangingPopupController;
  TimesliceChangingControl timesliceChangingControl;
}

- (void) beginReserving: sender
{
  [NotificationCenter postNotificationName: UserHasChosenTimeslice
				    object: [timesliceControl timeslice]];
}

- (void) prepareToFinishReservation
{
  [timesliceSummary summarize: [timesliceControl timeslice]];
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
  var view = "<a href='/reservation/" + reservationID + "' target='_blank'>";
  var note = "<a href='/2/reservation/" + reservationID + "/note' target='_blank'>";
  [linkToPreviousResults loadHTMLString:@"Click to " + view + "view the reservation</a> in another window or " + note + "add a note</a>."
               baseURL: nil];
  [copyButton setTag: reservationID];
  [previousResultsView setHidden: NO];
}

- (void) beginningOfReservationWorkflow
{
  [courseField selectText: nil];  // Doesn't actually work.
  [[courseField window] makeFirstResponder: courseField];
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
  var timeslice = [dictionary valueForKey: 'timeslice'];
  [timesliceControl setTimeslice: timeslice];
  [timesliceSummary summarize: timeslice];
}

- (void) startDestructivelyEditingTimeslice: sender
{
  [NotificationCenter postNotificationName: UserWantsToReplaceTimeslice
				    object: [timesliceControl timeslice]];
}


- (void) newTimesliceReady: newTimeslice
{
  [timesliceControl setTimeslice: newTimeslice];
  [timesliceSummary summarize: newTimeslice];
  [NotificationCenter postNotificationName: TimesliceForCurrentReservationChangedNews 
				    object: newTimeslice];
}




- (void) copyPreviousReservation: sender
{
  var id = [copyButton tag];
  [NotificationCenter postNotificationName: CopyReservationNews object: id];
}


// Util

- (void) showGroupEditButtons: value
{
  [majorModificationView setHidden: !value];
  [reserveButton setHidden: !value];
}

- (void) showDateAndTimeFields: value
{
  [dateGatheringView setHidden: !value];
  [timesliceSummary setHidden: value];
}

- (CPDictionary) data
{
  var dict = [CPDictionary dictionary];
  [dict setValue: [courseField stringValue] forKey: 'course'];
  [dict setValue: [instructorField stringValue] forKey: 'instructor'];


  [dict setValue: [timesliceControl timeslice] forKey: 'timeslice'];
  return dict;
}

// TODO: USED?
- (Timeslice) timeslice
{
  return [timesliceControl timeslice];
}
@end


