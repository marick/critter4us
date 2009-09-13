@import <Critter4Us/page-for-making-reservations/NamedObjectControllerPMR.j>
@import <Critter4US/model/Animal.j>
@import "ScenarioTestCase.j"

@implementation NamedObjectControllerPMRTest : ScenarioTestCase
{
  NamedObject detsy, aaab, cetsy, Abnot, aaa;
}

- (void)setUp
{
  sut = [[NamedObjectControllerPMR alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardCollaborators: ['available', 'used']];

  detsy = [[NamedObject alloc] initWithName: 'detsy'];
  aaab = [[NamedObject alloc] initWithName: 'aaab'];
  cetsy = [[NamedObject alloc] initWithName: 'cetsy'];
  Abnot = [[NamedObject alloc] initWithName: 'Abnot']
  aaaa = [[NamedObject alloc] initWithName: 'aaaa'];
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
      [sut.available shouldReceive: @selector(setContent:)
                                   with: [objects]];
      [sut.available shouldReceive: @selector(setNeedsDisplay:)
                                   with: YES];

      [sut.used shouldReceive: @selector(setContent:)
                                   with: [[]]];
      [sut.used shouldReceive: @selector(setNeedsDisplay:)
                                   with: YES];
    }
   ];
}

- (void) testInitialContentIsOrderedCaseInsensitiveAlphabetical
{

  var objects = [ detsy, aaab, cetsy, Abnot, aaaa];

  [scenario
    during: function() {
      [sut beginUsing: objects];
    } 
  behold: function() {
      [sut.available shouldReceive: @selector(setContent:)
                                   with: [ [aaaa, aaab, Abnot, cetsy, detsy] ]];
    }
   ];
}

- (void) testSelectionMovesAnimalFromAvailableToUsed
{
  CPLog('not done');
}

@end	
