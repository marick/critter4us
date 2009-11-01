@import "StepPMR.j"
@import "GatheringReservationDataStepPMR.j"

@implementation StoringReservationStepPMR : StepPMR
{
}

- (void) setUpNotifications
{
  [self notificationNamed: ReservationStoredNews
                    calls: @selector(finishReservation:)];
}

-(void) finishReservation: aNotification
{
  var reservationID = [aNotification object];
  [reservationDataController offerOperationsOnJustFinishedReservation: reservationID];
  // No need for afterResigningInFavorOf because next event comes from user.
  [self resignInFavorOf: GatheringReservationDataStepPMR];
}

@end
