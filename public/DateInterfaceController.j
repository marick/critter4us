@import "Controller.j"

@implementation DateInterfaceController : Controller
{
  PersistentStore persistentStore;
}

- (void)newDate:(id)sender
{
  var date = [sender stringValue];
  [[CPNotificationCenter defaultCenter]
               postNotificationName: @"date chosen" object: date];

  var exclusions = [persistentStore exclusionsForDate: date];
  [[CPNotificationCenter defaultCenter] postNotificationName: @"exclusions"
                                        object: exclusions];
}

@end
