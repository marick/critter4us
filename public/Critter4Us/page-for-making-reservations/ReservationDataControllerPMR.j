@import "../util/AwakeningObject.j"
@import "../util/Timeslice.j"
@import "../util/TimesliceSummarizer.j"


// This controller does way too many things!

@implementation ReservationDataControllerPMR : AwakeningObject
{
  CPTextField courseField;
  CPTextField instructorField;
  CPTextField firstDateField;
  CPTextField lastDateField;
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
  [firstDateField setStringValue: timeslice.firstDate];
  [lastDateField setStringValue: timeslice.lastDate];
  [timeControl setTimes: timeslice.times];
  [self noteTimeAndDate];
}

- (void) startDestructivelyEditingTimeslice: sender
{
  [dateTimeEditingPanelController appear];
  [dateTimeEditingControl setTimeslice: [self timeslice]];
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


  var timeslice = [Timeslice firstDate: [firstDateField stringValue]
			      lastDate: [lastDateField stringValue]
				 times: [timeControl times]];
  [dict setValue: timeslice forKey: 'timeslice'];
  return dict;
}

- (void) setTimeslice: (Timeslice) timeslice
{
  [firstDateField setStringValue: timeslice.firstDate];
  [lastDateField setStringValue: timeslice.lastDate];
  [timeControl setTimes: timeslice.times];
}

- (Timeslice) timeslice
{
  var retval = [Timeslice firstDate: [firstDateField stringValue]
			   lastDate: [lastDateField stringValue]
			      times: [timeControl times]];
  return retval;
}
@end


