@import <Critter4Us/page-for-making-reservations/WorkupHerdControllerPMR.j>
@import "ScenarioTestCase.j"

@implementation WorkupHerdControllerPMRTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[DropTarget alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasSidewaysCollaborators: ['animalController', 'procedureController']];
}

@end
