@import <Critter4Us/page-for-making-reservations/AnimalControllerPMR.j>
@import <Critter4US/model/Animal.j>
@import "ScenarioTestCase.j"

@implementation AnimalControllerPMRTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[AnimalControllerPMR alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardCollaborators: ['collectionView']];
}

- (void) testHandsAnimalsThemselvesToCollectionView
{
  var animals = [ [[Animal alloc] initWithName: 'betsy' kind: 'cow'],
                  [[Animal alloc] initWithName: 'josie' kind: 'horse']];

  [scenario
    during: function() {
      [sut beginUsing: animals];
    } 
  behold: function() {
      [sut.collectionView shouldReceive: @selector(setContent:)
                                   with: [animals]];
      [sut.collectionView shouldReceive: @selector(setNeedsDisplay:)
                                   with: YES];
    }
   ];
}

- (void) testProvidesDraggingInformationForCollectionView
{
  var animals = [ [[Animal alloc] initWithName: 'betsy' kind: 'cow'],
                  [[Animal alloc] initWithName: 'josie' kind: 'horse']];

  [sut beginUsing: animals];
  [self assert: [AnimalDragType]
        equals: [sut collectionView: UnusedArgument
                     dragTypesForItemsAtIndexes: UnusedArgument]];
  [self assert: [ animals[0] ] 
        equals: [sut collectionView: UnusedArgument
                     dataForItemsAtIndexes: [CPIndexSet indexSetWithIndex: 0]
                            forType: AnimalDragType]];
}

@end	
