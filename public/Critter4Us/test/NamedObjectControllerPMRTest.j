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
  var objects = [ [[NamedObject alloc] initWithName: 'betsy'],
                  [[NamedObject alloc] initWithName: 'josie']];

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

- (void) testInitialContentIsOrderedCaseInsensitiveAlphabetical
{
  var detsy = [[NamedObject alloc] initWithName: 'detsy'];
  var aaab = [[NamedObject alloc] initWithName: 'aaab'];
  var cetsy = [[NamedObject alloc] initWithName: 'cetsy'];
  var Abnot = [[NamedObject alloc] initWithName: 'Abnot']
  var aaaa = [[NamedObject alloc] initWithName: 'aaaa'];

  var objects = [ detsy, aaab, cetsy, Abnot, aaaa];

  [scenario
    during: function() {
      [sut beginUsing: objects];
    } 
  behold: function() {
      [sut.collectionView shouldReceive: @selector(setContent:)
                                   with: [ [aaaa, aaab, Abnot, cetsy, detsy] ]];
    }
   ];
}

@end	
