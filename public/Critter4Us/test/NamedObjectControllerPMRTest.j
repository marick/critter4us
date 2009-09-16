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
  [scenario sutHasUpwardCollaborators: ['available', 'used']];

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


- (void) testSelectionMovesAnimalFromAvailableToUsed
{
  var out1 = [[NamedObject alloc] initWithName: 'out1'];
  var out2 = [[NamedObject alloc] initWithName: 'out2'];
  [scenario 
    during: function() { 
      [sut objectsRemoved: [out1, out2] fromList: sut.available];
    }
  behold: function() { 
      [sut.used shouldReceive: @selector(addContent:)
                         with: [[out1, out2]]];
      [sut.used shouldReceive: @selector(setNeedsDisplay:)
                         with: YES];
    }];
}

- (void) testSelectionMovesAnimalFromUsedToAvailable
{
  var out1 = [[NamedObject alloc] initWithName: 'out1'];
  var out2 = [[NamedObject alloc] initWithName: 'out2'];
  [scenario 
    during: function() { 
      [sut objectsRemoved: [out1, out2] fromList: sut.used];
    }
  behold: function() { 
      [sut.available shouldReceive: @selector(addContent:)
                         with: [[out1, out2]]];
      [sut.available shouldReceive: @selector(setNeedsDisplay:)
                         with: YES];
    }];
}

- (void) testCanBackUpToBeginningOfReservationWorkflow
{
  [scenario
    previousAction: function() {
      [sut appear];
      [self assertTrue: [sut wouldShowPanel]];
      [sut.available setContent: [[NamedObject alloc] initWithName: 'a']];
      [sut.used setContent: [[NamedObject alloc] initWithName: 'u']];
    }
    during: function() {
      [sut beginningOfReservationWorkflow];
    }
  behold: function() {
      [sut.panel shouldReceive: @selector(orderOut:)];
    }
  andSo: function() {
      [self assertFalse: [sut wouldShowPanel]];
      [self assert: [] equals: [sut.used content]];
      [self assert: [] equals: [sut.available content]];
    }];
}


@end	
