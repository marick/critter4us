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
  [NotificationCenter postNotificationName: ReservationDataAvailable
                                    object: nil];
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

@end
