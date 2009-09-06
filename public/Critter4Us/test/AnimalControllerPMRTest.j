@import <Critter4Us/page-for-making-reservations/AnimalControllerPMR.j>
@import <Critter4Us/util/Time.j>
@import "ScenarioTestCase.j"

@implementation AnimalControllerPMRTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[AnimalControllerPMR alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardCollaborators: ['collectionView']]
}

@end	
