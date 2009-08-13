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

- (void)makeViewsAcceptData
{
  [buildingView setHidden:NO];
  [finishedView setHidden:YES];
}

- (void)displaySelectedSession
{
  [buildingView setHidden:YES];
  [finishedView setHidden:NO];

  var date = [dateField stringValue];
  var time = [self deduceTime];

  var instructor = [instructorField stringValue];
  var course = [courseField stringValue];

  var summaryText = [CPString stringWithFormat: "%s needs animals for %s on the %s of %s.", instructor, course, [time description], date];
  [summaryField setStringValue: summaryText];
}

- (void)sessionReady:(id)sender
{
  [NotificationCenter postNotificationName:CourseSessionDescribedNews
                                    object:nil];
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
