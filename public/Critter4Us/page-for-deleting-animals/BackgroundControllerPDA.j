@import <AppKit/AppKit.j>
@import "../util/AwakeningObject.j"

@implementation BackgroundControllerPDA : AwakeningObject
{
  CPTextField dateField;
}

- (void) animalsInServiceForDate: sender
{
  [NotificationCenter postNotificationName: UserWantsAnimalsInServiceOnDateNews
                                    object: [dateField stringValue]];
                      
}

@end
