@import <Critter4Us/page-for-making-reservations/CoordinatorPMR.j>
@import "ScenarioTestCase.j"

@implementation CoordinatorPMRTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[CoordinatorPMR alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardCollaborators: ['reservationDataController', 'animalController', 'procedureController', 'workupHerdController', 'pageController']];
  [scenario sutHasDownwardCollaborators: ['persistentStore']];
}

- (void) testTellsPanelsToAppearWhenReservationReady
{
  [scenario
    during: function() {
      [self sendNotification: ReservationDataAvailable withObject: nil];
    }
  behold: function() {
      [sut.procedureController shouldReceive:@selector(appear)];
      [sut.animalController shouldReceive:@selector(appear)];
      [sut.workupHerdController shouldReceive:@selector(appear)];
    }];
}

@end
