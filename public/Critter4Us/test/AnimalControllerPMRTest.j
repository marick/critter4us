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

- (void) testHandsAnimalNamesToCollectionView
{
  var animals = [ [[Animal alloc] initWithName: 'betsy' kind: 'cow'],
                  [[Animal alloc] initWithName: 'josie' kind: 'horse']];

  [scenario
    during: function() {
      [sut beginUsing: animals];
    } 
  behold: function() {
      [sut.collectionView shouldReceive: @selector(setContent:)
                                   with: [['betsy (cow)', 'josie (horse)']]];
      [sut.collectionView shouldReceive: @selector(setNeedsDisplay:)
                                   with: YES];
    }
   ];
}

@end	
