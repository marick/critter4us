
@import "Controller.j"

@implementation CourseSessionController : Controller
{
  PersistentStore persistentStore;

  CPView buildingView; // contains
    CPTextField courseField;
    CPTextField instructorField;
    CPTextField dateField;
    CPRadio morningButton;

  CPView finishedView; // contains
    CPTextField summaryField;
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
  [NotificationCenter postNotificationName:CourseSessionDescribedNews
                                    object:nil];

  var date = [dateField stringValue];
  var exclusions = [persistentStore exclusionsForDate: date];
  [NotificationCenter postNotificationName:SessionExclusionsNews
                                    object:exclusions];

  var instructor = [instructorField stringValue];
  var course = [courseField stringValue];
  var morning = [morningButton state] == CPOnState ? "morning" : "afternoon";

  var summaryText = [CPString stringWithFormat: "%s needs animals for %s on the %s of %s.", instructor, course, morning, date];
  [summaryField setStringValue: summaryText];
				 
  [buildingView setHidden:YES];
  [finishedView setHidden:NO];

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
