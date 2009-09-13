@import <Critter4Us/page-for-making-reservations/ProcedureControllerPMR.j>
@import <Critter4US/model/Procedure.j>
@import "ScenarioTestCase.j"

@implementation ProcedureControllerPMRTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[ProcedureControllerPMR alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardCollaborators: ['collectionView']];
}


@end	
