@import <AppKit/AppKit.j>
@import "../util/AwakeningObject.j"

@implementation BackgroundControllerPDA : AwakeningObject
{
  CPTextField dateField;
  CPTextField noteSelectedDateField;
  CPView changeableDateView;
  CPView fixedDateView;
}

- (void) animalsInServiceForDate: sender
{
  [NotificationCenter postNotificationName: UserWantsAnimalsInServiceOnDateNews
                                    object: [self effectiveDate]];
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
