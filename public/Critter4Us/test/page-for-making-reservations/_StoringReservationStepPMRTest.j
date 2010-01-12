@import <Critter4Us/page-for-making-reservations/state-machine/StoringReservationStepPMR.j>
@import <Critter4Us/util/Time.j>
@import <Critter4Us/test/testutil/ScenarioTestCase.j>

@implementation _StoringReservationStepPMRTest : ScenarioTestCase
{
}

- (void) setUp
{
  sut = [StoringReservationStepPMR alloc];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutWillBeGiven: ['reservationDataController', 'animalController', 'procedureController', 'groupController', 'currentGroupPanelController', 'persistentStore', 'master']];
  [sut initWithMaster: sut.master];
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
      [sut.master shouldReceive: @selector(takeStep:)
                           with: GatheringReservationDataStepPMR];
      
    }];
}

@end
