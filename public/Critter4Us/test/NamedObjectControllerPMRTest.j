@import <Critter4Us/page-for-making-reservations/NamedObjectControllerPMR.j>
@import <Critter4US/model/Animal.j>
@import "ScenarioTestCase.j"

@implementation NamedObjectControllerPMRTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[NamedObjectControllerPMR alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardCollaborators: ['collectionView']];
}

- (void) testHandsObjectsThemselvesToCollectionView
{
  var objects = [ [[Animal alloc] initWithName: 'betsy' kind: 'cow'],
                  [[Animal alloc] initWithName: 'josie' kind: 'horse']];

  [scenario
    during: function() {
      [sut beginUsing: objects];
    } 
  behold: function() {
      [sut.collectionView shouldReceive: @selector(setContent:)
                                   with: [objects]];
      [sut.collectionView shouldReceive: @selector(setNeedsDisplay:)
                                   with: YES];
    }
   ];
}

@end	
