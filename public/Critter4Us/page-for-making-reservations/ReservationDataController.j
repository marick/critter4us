@import "../util/AwakeningObject.j"
@import "../util/Time.j"

@implementation ReservationDataController : AwakeningObject
{
  CPTextField courseField;
  CPTextField instructorField;
  CPTextField dateField;
  CPRadio morningButton;

  CPButton beginButton;
  CPButton reserveButton;
  CPButton restartButton;
}

- (void) commitToReservation: sender
{
  [courseField setEnabled: NO];
  [instructorField setEnabled: NO];
  [dateField setEnabled: NO];
  [morningButton setEnabled: NO];

  [beginButton setHidden: YES];
  [reserveButton setHidden: NO];
  [restartButton setHidden: NO];

  [NotificationCenter postNotificationName:CourseSessionDescribedNews
                                    object:nil];
}

- (id) spillIt: (CPMutableDictionary) dict
{
  [dict setValue: [courseField stringValue] forKey: 'course'];
  [dict setValue: [instructorField stringValue] forKey: 'instructor'];
  [dict setValue: [dateField stringValue] forKey: 'date'];
  [dict setValue: [self deduceTime] forKey: 'time'];
}

// Util

- (id) deduceTime
{
  if ([morningButton state] == CPOnState) 
    return [Time morning];
  else
    return [Time afternoon];
}

- (id) setIt: (id) jsHash
{
  [courseField setStringValue: jsHash['course']];
  [instructorField setStringValue: jsHash['instructor']];
  [dateField setStringValue: jsHash['date']];
  if (jsHash['time'] === [Time morning])
    [morningButton setState: CPOnState];
  else
    [morningButton setState: CPOffState];
}

@end
