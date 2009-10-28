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
  [reservationDataController offerReservationView: reservationID];
  [self resignInFavorOf: GatheringReservationDataStepPMR];
}

@end
