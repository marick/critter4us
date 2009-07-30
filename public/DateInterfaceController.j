@import <Foundation/CPObject.j>


@implementation DateInterfaceController : CPObject
{
  PersistentStore persistentStore;
}

- (void)newDate:(id)sender
{
  var date = [sender stringValue];
  [[CPNotificationCenter defaultCenter]
               postNotificationName: @"date chosen" object: nil];

  var exclusions = [persistentStore exclusionsForDate: date];
  [[CPNotificationCenter defaultCenter] postNotificationName: @"exclusions"
                                        object: exclusions];
}

@end
