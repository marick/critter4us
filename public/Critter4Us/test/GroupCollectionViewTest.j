@import <Critter4Us/view/GroupCollectionView.j>
@import "ScenarioTestCase.j"

@implementation GroupCollectionViewTest : ScenarioTestCase
{
  GroupCollectionView sut;
  
  Animal betsy;
  Animal jake;
  Procedure floating;
  Procedure radiology;

  Group noProcedureGroup;
  Group oneProcedureGroup;
}

- (void) setUp
{
  sut = [[GroupCollectionView alloc] initWithFrame: CGRectMakeZero()];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  // [scenario sutHasDownwardCollaborators: ['delegate']];

  betsy = [[Animal alloc] initWithName: 'betsy' kind: 'cow'];
  jake = [[Animal alloc] initWithName: 'jake' kind: 'cow'];
  floating = [[Procedure alloc] initWithName: 'floating'];
  radiology = [[Procedure alloc] initWithName: 'radiology'];

  oneProcedureGroup = [[Group alloc] initWithProcedures: [radiology]
                                                animals: [betsy]];
  noProcedureGroup = [[Group alloc] initWithProcedures: []
                                                animals: [betsy]];
}

- (void) testInitialButtonTitleIsBuiltFromProcedureContents
{
  [sut setContent: [oneProcedureGroup]];
  [self assert: [oneProcedureGroup name]
        equals: [self titleForItem: 0]];
}

- (void) test_butAnEmptyTitleIsReplacedWithSomethingDescriptive
{
  [sut setContent: [noProcedureGroup]];
  [self assert: "* No procedures chosen *"
        equals: [self titleForItem: 0]];
}


// util

- (CPString) titleForItem: index
{
  var item = [[sut items] objectAtIndex: 0];
  var view = [item view];
  return [view title];
}

@end
