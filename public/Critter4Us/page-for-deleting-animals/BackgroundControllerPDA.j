@import <AppKit/AppKit.j>
@import "../util/AwakeningObject.j"

@implementation BackgroundControllerPDA : AwakeningObject
{
  CPTextField dateField;
  CPTextField noteSelectedDateField;
  CPView changeableDateView;
  CPView fixedDateView;
  CPWebview pendingReservationView;
}

- (void) animalsInServiceForDate: sender
{
  [NotificationCenter postNotificationName: UserWantsAnimalsThatCanBeRemovedFromService
                                    object: [self effectiveDate]];
}

- (void) restart: sender
{
  [NotificationCenter postNotificationName: RestartAnimalRemovalStateMachineNews
                                    object: nil];
}

- (void) showAnimalsWithPendingReservations: html
{
  [pendingReservationView loadHTMLString: html baseURL: nil];
}



- (CPString) effectiveDate
{
  return [dateField stringValue];
}

- (void) allowDateEntry
{
  [changeableDateView setHidden: NO];
  [fixedDateView setHidden: YES];
}

- (void) forbidDateEntry
{
  [changeableDateView setHidden: YES];
  [fixedDateView setHidden: NO];
  [noteSelectedDateField setStringValue: [CPString stringWithFormat: "Animals chosen will be taken out of service as of %s.", [dateField stringValue]]];
}

@end
