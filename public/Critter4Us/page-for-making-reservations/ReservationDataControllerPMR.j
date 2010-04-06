@import "../util/AwakeningObject.j"
@import "../util/Timeslice.j"
@import "../util/TimesliceSummarizer.j"
@import "../view/DualDateControl.j"


// This controller does way too many things!

@implementation ReservationDataControllerPMR : AwakeningObject
{
  CPTextField courseField;
  CPTextField instructorField;

  DualDateControl dateControl;
  TimeControl timeControl;

  CPButton beginButton;
  CPButton reserveButton;

  CPView previousResultsView;
  CPWebView linkToPreviousResults;
  CPButton copyButton;

  CPView dateGatheringView;
  CPView dateDisplayingView;
  CPView majorModificationView;
  CPTextField dateTimeSummary;

  PanelController dateTimeEditingPanelController;
  DateTimeEditingControl dateTimeEditingControl;
}

- (void) beginReserving: sender
{
  [NotificationCenter postNotificationName: UserHasChosenTimeslice
				    object: [self timeslice]];
}

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
  [dateControl setFirst: timeslice.firstDate last: timeslice.lastDate];
  [timeControl setTimes: timeslice.times];
  [self noteTimeAndDate];
}

- (void) startDestructivelyEditingTimeslice: sender
{
  [dateTimeEditingPanelController appear];
  var timeslice = [self timeslice];
  [dateTimeEditingControl setTimeslice: timeslice];
}

- (void) forgetEditingTimeslice: sender
{
  [dateTimeEditingPanelController disappear];
}


- (void) newTimesliceReady: sender
{
  [dateTimeEditingPanelController disappear];
  var newTimeslice = [dateTimeEditingControl timeslice];
  [self setTimeslice: newTimeslice];
  [self noteTimeAndDate];
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
  [dateDisplayingView setHidden: value];
}

- (void) noteTimeAndDate
{
  var summarizer = [[TimesliceSummarizer alloc] init];
  [dateTimeSummary setStringValue: [summarizer summarize: [self timeslice]]+"."];
}

- (CPDictionary) data
{
  var dict = [CPDictionary dictionary];
  [dict setValue: [courseField stringValue] forKey: 'course'];
  [dict setValue: [instructorField stringValue] forKey: 'instructor'];


  var timeslice = [Timeslice firstDate: [dateControl firstDate]
			      lastDate: [dateControl lastDate]
				 times: [timeControl times]];
  [dict setValue: timeslice forKey: 'timeslice'];
  return dict;
}

- (void) setTimeslice: (Timeslice) timeslice
{
  [dateControl setFirst: timeslice.firstDate last: timeslice.lastDate];
  [timeControl setTimes: timeslice.times];
}

- (Timeslice) timeslice
{
  var retval = [Timeslice firstDate: [dateControl firstDate]
			   lastDate: [dateControl lastDate]
			      times: [timeControl times]];
  return retval;
}
@end


