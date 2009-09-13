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

- (void) testProvidesDraggingInformationForCollectionView
{
  var procedures = [ [[Procedure alloc] initWithName: 'betsy'],
                  [[Procedure alloc] initWithName: 'josie']];

  [sut beginUsing: procedures];
  [self assert: [ProcedureDragType]
        equals: [sut collectionView: UnusedArgument
                     dragTypesForItemsAtIndexes: UnusedArgument]];
  [self assert: [ procedures[0] ] 
        equals: [sut collectionView: UnusedArgument
                     dataForItemsAtIndexes: [CPIndexSet indexSetWithIndex: 0]
                            forType: ProcedureDragType]];
}

@end	
