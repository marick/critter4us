@import <Foundation/CPObject.j>


@implementation MainWindowController : CPObject
{
  CPWindow theWindow;
  PersistentStore persistentStore;
}

- (void)newDate:(id)sender
{
  var date = [sender stringValue];
  var exclusions = [persistentStore exclusionsForDate: date];
  [[CPNotificationCenter defaultCenter] postNotificationName: @"exclusions"
                                        object: exclusions];
}

@end
