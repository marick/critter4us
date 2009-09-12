@import <Critter4Us/page-for-making-reservations/WorkupHerdControllerPMR.j>
@import "ScenarioTestCase.j"

@implementation WorkupHerdControllerPMRTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[WorkupHerdControllerPMR alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardCollaborators: ['newWorkupHerdButton', 'procedureDropTarget', 'procedureCollectionView', 'animalDropTarget', 'animalCollectionView']];
}

-(void) testInitialBehavior
{
  [scenario
   whileAwakening: function() {
      [sut.animalDropTarget shouldReceive: @selector(acceptDragType:)
                                     with: [AnimalDragType]];
      [sut.animalDropTarget shouldReceive: @selector(setNormalColor:andHoverColor:)
                                     with: [AnimalHintColor, AnimalStrongHintColor]];
    }];
}


@end
