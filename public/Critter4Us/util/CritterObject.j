@import "Constants.j"

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

- (void) log: (CPString) format, ...
{
  var text = sprintf.apply(this, Array.prototype.slice.call(arguments, 2));
  [[Logger defaultLogger] log: "%@: %s", [self hash], text];
}


@end
