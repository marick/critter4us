@import <Critter4Us/controller/FromToNamedObjectListController.j>
@import <Critter4Us/view/NamedObjectCollectionView.j>
@import <Critter4Us/model/NamedObject.j>
@import <Critter4Us/model/Group.j>
@import <Critter4Us/test/testutil/ScenarioTestCase.j>

@implementation FromToNamedObjectListControllerTest : ScenarioTestCase
{
  NamedObject betsy;
  NamedObject spike;
  NamedObject fang;
}

- (void)setUp
{
  sut = [[FromToNamedObjectListController alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardCollaborators: ['available', 'used']];

  betsy = [[NamedObject alloc] initWithName: 'betsy'];
  spike = [[NamedObject alloc] initWithName: 'spike'];
  fang = [[NamedObject alloc] initWithName: 'fang'];
}

-(void) testBeginning
{
  [scenario 
    during: function() {
      [sut allPossibleObjects: [betsy, spike, fang]];
    }
    behold: function() { 
      [sut.available shouldReceive: @selector(setNeedsDisplay:) with: YES];
      [sut.used shouldReceive: @selector(setNeedsDisplay:) with: YES];
    }
    andSo: function() {
      [self assert: [betsy, spike, fang]
            equals: [sut.available content]];
      [self assert: []
            equals: [sut.used content]];
    }];
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



- (void) testCanInitializeUsedArrayFromASource
{
  [scenario 
    previously: function() { 
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


- (void) testCanMoveAllUsedObjectsBack
{
  var a = [[NamedObject alloc] initWithName: 'a'];
  var b = [[NamedObject alloc] initWithName: 'b'];
  var c = [[NamedObject alloc] initWithName: 'c'];
  [scenario
    previously: function() { 
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



- (void) testCanReturnUsedObjects
{
  sut.used = [[NamedObjectCollectionView alloc] initWithFrame: CGRectMakeZero()]
  sut.available = [[NamedObjectCollectionView alloc] initWithFrame: CGRectMakeZero()]
  [sut presetUsed: [betsy, spike, fang]];
  [self assert: [betsy, fang, spike] equals: [sut usedObjects]];
}


- (void) testCanReturnUsedObjectNames
{
  sut.used = [[NamedObjectCollectionView alloc] initWithFrame: CGRectMakeZero()]
  sut.available = [[NamedObjectCollectionView alloc] initWithFrame: CGRectMakeZero()]
  [sut presetUsed: [betsy, spike, fang]];
  [self assert: ['betsy', 'fang', 'spike'] equals: [sut usedNames]];
}

- (void) test_can_empty_both_lists
{
  sut.used = [[NamedObjectCollectionView alloc] initWithFrame: CGRectMakeZero()]
  sut.available = [[NamedObjectCollectionView alloc] initWithFrame: CGRectMakeZero()]
  [sut allPossibleObjects: [betsy, spike, fang]];
  [sut presetUsed: [betsy]];
  [self assertFalse: [[sut.used content] isEqual: []]];
  [self assertFalse: [[sut.available content] isEqual: []]];

  [sut emptyLists];

  [self assert: [] equals: [sut.used content]];
  [self assert: [] equals: [sut.available content]];
}


@end	
