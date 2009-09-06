@import <Critter4Us/page-for-making-reservations/PageControllerPMR.j>
@import "ScenarioTestCase.j"

@implementation PageControllerPMRTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[PageControllerPMR alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];

  [scenario sutHasUpwardCollaborators:
              ['pageView', 'workupHerdPanel', 'animalDragList', 'procedureDragList']];
}


@end
