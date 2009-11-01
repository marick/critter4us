@import <Critter4Us/page-for-making-reservations/state-machine/StoringReservationStepPMR.j>
@import "StateMachineTestCase.j"
@import <Critter4Us/util/Time.j>


@implementation StoringReservationStepPMRTest : StateMachineTestCase
{
}

- (void) setUp
{
  sut = [StoringReservationStepPMR alloc];
  [super setUp];
}

- (void) test_start_by_doing_nothing
{
}

- (void) test_confirmation_of_reservation_makes_it_available_and_starts_over
{
  [scenario
    during: function() {
      [self sendNotification: ReservationStoredNews withObject: 5];
    }
  behold: function() {
      [sut.reservationDataController shouldReceive: @selector(offerOperationsOnJustFinishedReservation:)
                                              with: 5];
      [sut.master shouldReceive: @selector(nextStep:)
                           with: GatheringReservationDataStepPMR];
      
    }];
}

@end
