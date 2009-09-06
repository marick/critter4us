@import <Critter4Us/view/DropTarget.j>
@import "ScenarioTestCase.j"

@implementation DropTargetTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[DropTarget alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasSidewaysCollaborators: ['collectionView']];
}

@end
