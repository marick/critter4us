@import <Foundation/Foundation.j>
@import "FakeMainWindowCib.j"

@implementation App : CPObject
{
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
  [FakeMainWindowCib load];
}

@end
