
@implementation CritterObject : CPObject
{
}

- (void) setUpNotifications
{
}

- (void) notificationNamed: name calls: (SEL) selector
{
  [NotificationCenter addObserver: self selector: selector name: name object: nil];
}


- (void) stopObserving
{
  [[CPNotificationCenter defaultCenter] removeObserver: self];
}
@end
