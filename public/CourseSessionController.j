
@import "Controller.j"

@implementation CourseSessionController : Controller
{
  PersistentStore persistentStore;
  CPTextField courseField;
  CPTextField instructorField;
  CPTextField dateField;
  CPRadio morningButton;
}

- (void) setUpNotifications
{
  [NotificationCenter addObserver:self
                         selector:@selector(courseSessionRequested:)
                             name:NeedForSessionDataNews
                           object:nil];
}

- (void)sessionReady:(id)sender
{
  var date = [dateField stringValue];
  [NotificationCenter postNotificationName:CourseSessionDescribedNews
                                    object:nil];

  var exclusions = [persistentStore exclusionsForDate: date];
  [NotificationCenter postNotificationName:SessionExclusionsNews
                                    object:exclusions];
}

- (void) courseSessionRequested: aNotification
{
  [[aNotification object] courseSession: [self allMyData]];
}

- (id) allMyData
{
  var course = [courseField stringValue];
  var instructor = [instructorField stringValue];
  var date = [dateField stringValue];
  var isMorning = ([morningButton state] == CPOnState);
  return {'course':course,'instructor':instructor,'date':date,
          'isMorning':isMorning};
}

@end
