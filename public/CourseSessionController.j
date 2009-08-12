@import "AwakeningObject.j"
@import "Time.j"

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


- (void)makeViewsAcceptData
{
  [buildingView setHidden:NO];
  [finishedView setHidden:YES];
}



- (void)sessionReady:(id)sender
{
  [NotificationCenter postNotificationName:CourseSessionDescribedNews
                                    object:nil];

  var date = [dateField stringValue];
  var time = [self deduceTime];

  var exclusions = [persistentStore exclusionsForDate: date time: time];
  [NotificationCenter postNotificationName:SessionExclusionsNews
                                    object:exclusions];

  var instructor = [instructorField stringValue];
  var course = [courseField stringValue];

  var summaryText = [CPString stringWithFormat: "%s needs animals for %s on the %s of %s.", instructor, course, [time description], date];
  [summaryField setStringValue: summaryText];
				 
  [buildingView setHidden:YES];
  [finishedView setHidden:NO];

}

- (id) deduceTime
{
  if ([morningButton state] == CPOnState) 
    return [Time morning];
  else
    return [Time afternoon];
}

- (id) spillIt: (CPMutableDictionary) dict
{
  [dict setValue: [courseField stringValue] forKey: 'course'];
  [dict setValue: [instructorField stringValue] forKey: 'instructor'];
  [dict setValue: [dateField stringValue] forKey: 'date'];
  [dict setValue: [self deduceTime] forKey: 'time'];
}

@end
