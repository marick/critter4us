@import "Controller.j"

@implementation DateInterfaceController : Controller
{
  PersistentStore persistentStore;
  CPTextField sourceField;
  CPTextField instructorField;
  CPTextField dateField;
  CPRadio morningButton;
}

- (void)newDate:(id)sender
{
  var date = [sender stringValue];
  [[CPNotificationCenter defaultCenter]
               postNotificationName: @"date chosen" object: date];

  alert([morningButton state] == CPOnState);

  var exclusions = [persistentStore exclusionsForDate: date];
  [[CPNotificationCenter defaultCenter] postNotificationName: @"exclusions"
                                        object: exclusions];
}

@end
