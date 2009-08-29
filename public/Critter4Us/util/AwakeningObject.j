@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>
@import "Constants.j"

@implementation AwakeningObject : CPObject
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
