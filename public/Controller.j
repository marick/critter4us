@import <Foundation/Foundation.j>
@import "Constants.j"

@implementation Controller : CPObject
{

  // For testing
  BOOL awakened;
}

- (void)awakeFromCib
{
  awakened = YES;
  [self setUpNotifications];
}

- (void) setUpNotifications
{
}

- (void) stopObserving
{
  [[CPNotificationCenter defaultCenter] removeObserver: self];
}


@end
