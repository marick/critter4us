@import "../util/AwakeningObject.j"
@import "../util/Time.j"

@implementation ReservationDataControllerPMR : AwakeningObject
{
  CPTextField courseField;
  CPTextField instructorField;
  CPTextField dateField;
  CPRadio morningButton;
  CPRadio afternoonButton;

  CPButton beginButton;
  CPButton reserveButton;
  CPButton restartButton;

  CPWebView linkToPreviousResults;
}

- (void) beginReserving: sender
{
  var data = [CPDictionary dictionary];
  [data setValue: [dateField stringValue] forKey: 'date'];
  time = ([morningButton state] == CPOnState) ? [Time morning] : [Time afternoon];
  [data setValue: time forKey: 'time'];

  [NotificationCenter postNotificationName: ReservationDataAvailable
                                    object: data];
}

- (void) allowNoDataChanges
{
  [courseField setEnabled: NO];
  [instructorField setEnabled: NO];
  [dateField setEnabled: NO];
  [morningButton setEnabled: NO];
  [afternoonButton setEnabled: NO];
  [beginButton setEnabled: NO];
}

- (void) prepareToFinishReservation
{
  [beginButton setHidden: YES];
  [restartButton setHidden: NO];
  [reserveButton setHidden: NO];
}

- (void) makeReservation: sender
{
  [NotificationCenter postNotificationName: TimeToReserveNews object: nil];
}

- (id) spillIt: (CPMutableDictionary) dict
{
  [dict setValue: [courseField stringValue] forKey: 'course'];
  [dict setValue: [instructorField stringValue] forKey: 'instructor'];
  [dict setValue: [dateField stringValue] forKey: 'date'];
  [dict setValue: [self deduceTime] forKey: 'time'];
}

- (id) deduceTime
{
  if ([morningButton state] == CPOnState) 
    return [Time morning];
  else
    return [Time afternoon];
}


@end
