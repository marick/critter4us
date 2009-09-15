@import <Critter4Us/page-for-making-reservations/WorkupHerdControllerPMR.j>
@import "ScenarioTestCase.j"
@import <Critter4Us/model/Animal.j>

@implementation WorkupHerdControllerPMRTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[WorkupHerdControllerPMR alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardCollaborators: ['procedureCollectionView', 'animalCollectionView']];
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
      [sut receiveNewItem: [animalB]];
    }
  behold: function() {
      [sut.animalCollectionView shouldReceive: @selector(content)
                                    andReturn: [animalC, animalA]];
      [sut.animalCollectionView shouldReceive: @selector(setContent:)
                                         with: [[animalA, animalB, animalC]]];
    }];
}

- (void) testRestarting
{
  [scenario
    previousAction: function() {
      [sut appear];
      [self assertTrue: [sut wouldShowPanel]];
      [sut.animalCollectionView setContent: [[NamedObject alloc] initWithName: 'a']];
      [sut.procedureCollectionView setContent: [[NamedObject alloc] initWithName: 'u']];
    }
    during: function() {
      [sut restart];
    }
  behold: function() {
      [sut.panel shouldReceive: @selector(orderOut:)];
    }
  andSo: function() {
      [self assertFalse: [sut wouldShowPanel]];
      [self assert: [] equals: [sut.procedureCollectionView content]];
      [self assert: [] equals: [sut.animalCollectionView content]];
    }];
}


@end
