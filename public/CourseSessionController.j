
@import "Controller.j"

@implementation CourseSessionController : Controller
{
  PersistentStore persistentStore;
  CPTextField courseField;
  CPTextField instructorField;
  CPTextField dateField;
  CPRadio morningButton;
}

- (void)sessionReady:(id)sender
{
  var date = [dateField stringValue];
  [[CPNotificationCenter defaultCenter]
               postNotificationName: DateChosenNews object: date];

  var exclusions = [persistentStore exclusionsForDate: date];
  [[CPNotificationCenter defaultCenter] postNotificationName: SessionExclusionsNews
                                        object: exclusions];
}

@end
