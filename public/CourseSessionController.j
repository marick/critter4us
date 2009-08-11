
@import "AwakeningObject.j"

@implementation CourseSessionController : AwakeningObject
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

- (id) spillIt: (CPMutableDictionary) dict
{
  [dict setValue: [courseField stringValue] forKey: 'course'];
  [dict setValue: [instructorField stringValue] forKey: 'instructor'];
  [dict setValue: [dateField stringValue] forKey: 'date'];
  [dict setValue: ([morningButton state] == CPOnState) forKey: 'isMorning'];
}

@end
