@import <Critter4Us/page-for-making-reservations/NamedObjectControllerPMR.j>
@import <Critter4Us/model/NamedObject.j>
@import <Critter4Us/model/Group.j>
@import "ScenarioTestCase.j"

@implementation NamedObjectControllerPMRTest : ScenarioTestCase
{
  NamedObject betsy;
  NamedObject spike;
  NamedObject fang;
}

- (void)setUp
{
  sut = [[NamedObjectControllerPMR alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardCollaborators: ['available', 'used']];

  betsy = [[NamedObject alloc] initWithName: 'betsy'];
  spike = [[NamedObject alloc] initWithName: 'spike'];
  fang = [[NamedObject alloc] initWithName: 'fang'];
}

- (void) testHandsObjectsThemselvesToCollectionView
{
  var objects = [betsy, spike];

  [scenario
    during: function() {
      [sut allPossibleObjects: objects];
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

- (void) testSelectionMovesObjectFromAvailableToUsed
{
  [scenario 
    during: function() { 
      [sut objectsRemoved: [betsy, spike] fromList: sut.available];
    }
  behold: function() { 
      [sut.used shouldReceive: @selector(addContent:)
                         with: [[betsy, spike]]];
      [sut.used shouldReceive: @selector(setNeedsDisplay:)
                         with: YES];
    }];
}

- (void) testSelectionMovesObjectFromUsedToAvailable
{
  [scenario 
    during: function() { 
      [sut objectsRemoved: [betsy, spike] fromList: sut.used];
    }
  behold: function() { 
      [sut.available shouldReceive: @selector(addContent:)
                         with: [[betsy, spike]]];
      [sut.available shouldReceive: @selector(setNeedsDisplay:)
                         with: YES];
    }];
}

- (void)testMovingAnObjectAnnouncesUsedListIsUpdated
{
  [scenario
   previousAction: function() {
      [sut allPossibleObjects: [betsy, spike]];
    }
  during: function() {
      [sut objectsRemoved: [betsy] fromList: sut.available];
    }
  behold: function() {
      [sut.used shouldReceive: @selector(content)
                    andReturn: [betsy]];
            [self listenersWillReceiveNotification: DifferentObjectsUsedNews
                                  containingObject: sut
                                            andKey: 'used'
                                              with: [betsy]];
    }];
}


- (void) testCanInitializedUsedArrayFromASource
{
  [scenario 
    previousAction: function() { 
      [sut allPossibleObjects: [betsy, spike, fang]];
    }
    testAction: function() { 
      [sut presetUsed: [betsy, fang] ];
    }
  andSo: function() {
      [self assert: [spike] equals: [sut.available content]];
      [self assert: [betsy, fang] equals: [sut.used content]];
    }];
}


- (void) presetsDoNotCountAsNotifiableMovement
{
  [scenario 
    previousAction: function() { 
      [sut allPossibleObjects: [betsy, spike, fang]];
    }
    during: function() { 
      [sut presetUsed: [betsy, fang] ];
    }
  behold: function() {
      [self listenersHearNothing];
    }];
}





- (void) testCanMoveAllUsedObjectsBack
{
  var a = [[NamedObject alloc] initWithName: 'a'];
  var b = [[NamedObject alloc] initWithName: 'b'];
  var c = [[NamedObject alloc] initWithName: 'c'];
  [scenario
    previousAction: function() { 
      [sut allPossibleObjects: [a, b, c]];
      [sut presetUsed: [b, c]];
    }
    testAction: function() {
      [sut stopUsingAll];
    }
  andSo: function() {
      [self assert: [a, b, c]
            equals: [sut.available content]];
      [self assert: []
            equals: [sut.used content]];
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
