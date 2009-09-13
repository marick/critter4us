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

-(void) testCanReceiveNewItemOnBehalfOfACollectionAndPutItIn
{
  var zz = [[Animal alloc] initWithName: 'zz' kind: 'x'];
  var one = [[Animal alloc] initWithName: 'one' kind: 'x'];
  var two = [[Animal alloc] initWithName: 'two' kind: 'x'];
  [scenario
    during: function() {
      return [sut receiveNewItem: [zz]];
    }
  behold: function() {
      [sut.animalCollectionView shouldReceive: @selector(content)
                                    andReturn: [one, two]];
      [sut.animalCollectionView shouldReceive: @selector(setContent:)
                                   with: [[one, two, zz]]];
      [sut.animalCollectionView shouldReceive: @selector(setNeedsDisplay:)
                                         with: YES];
    }
  andSo: function() {
      [self assertTrue: scenario.result];
    }];
}

-(void) testTheResultingCollectionIsSorted
{
  var animalA = [[Animal alloc] initWithName: 'a' kind: 'Z'];
  var animalB = [[Animal alloc] initWithName: 'b' kind: '-'];
  var animalC = [[Animal alloc] initWithName: 'c' kind: ''];

  [scenario
    during: function() {
      [sut receiveNewItem: animalB];
    }
  behold: function() {
      [sut.animalCollectionView shouldReceive: @selector(content)
                                    andReturn: [animalC, animalA]];
      [sut.animalCollectionView shouldReceive: @selector(setContent:)
                                         with: [[animalA, animalB, animalC]]];
    }];
}


@end
