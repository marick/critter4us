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
  Group twoProcedureGroup;
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

  twoProcedureGroup = [[Group alloc] initWithProcedures: [radiology, floating]
                                                animals: [betsy]];
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

- (void) test_theItemCanBeToldToRefreshItsTitle
{
  [sut setContent: [oneProcedureGroup]];
  [self assert: [oneProcedureGroup name]
        equals: [self titleForItem: 0]];
  [sut setContent: [twoProcedureGroup]];
  [sut refreshTitleForItemAtIndex: 0];
  [self assert: [twoProcedureGroup name]
        equals: [self titleForItem: 0]];
}


// util

- (CPString) titleForItem: index
{
  return [[self buttonAt: index] title];
}

- (CPBoolean) isHighlighted: index
{
  
  var button = [self buttonAt: index];
  return [[button themeState] isEqual: CPThemeStateDefault];
}

- (CPString) buttonAt: index
{
  var item = [[sut items] objectAtIndex: index];
  return [item view];
}


@end
