@import <Critter4Us/controller/NamedObjectListController.j>
@import <Critter4Us/view/NamedObjectCollectionView.j>
@import <Critter4Us/model/NamedObject.j>
@import <Critter4Us/model/Group.j>
@import "ScenarioTestCase.j"

@implementation NamedObjectListControllerTest : ScenarioTestCase
{
  NamedObject betsy;
  NamedObject spike;
  NamedObject fang;
}

- (void)setUp
{
  sut = [[NamedObjectListController alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardCollaborators: ['available']];

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
    }
    andSo: function() {
      [self assert: [betsy, spike, fang]
            equals: [sut.available content]];
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
    }
   ];
}



- (void)testWithholdingNamedObjectsLeavesThemOutOfAvailableList
{
  [scenario
   previously: function() {
      [sut allPossibleObjects: [betsy, spike, fang]];
    }
  during: function() { 
      [sut withholdNamedObjects: [fang, betsy]];
    }
  behold: function() {
      [sut.available shouldReceive: @selector(setNeedsDisplay:) with: YES];
    }
  andSo: function() {
      [self assert: [spike]
            equals: [sut.available content]];
    }];
}

- (void)testWithholdingDoes_NOT_Accumulate
{
  [scenario
   previously: function() {
      [sut allPossibleObjects: [betsy, spike, fang]];
      [sut withholdNamedObjects: [betsy]];
    }
  testAction: function() {
      [sut withholdNamedObjects: [spike]];
    }
  andSo: function() {
      [self assert: [betsy, fang]
            equals: [sut.available content]];
    }];
}

- (void)testWithholdingNamedObjectsNeedNotBePermanent
{
  [scenario
   previously: function() { 
      [sut allPossibleObjects: [betsy, spike, fang]];
      [sut withholdNamedObjects: [fang, betsy]];
    }
  testAction: function() { 
      [sut withholdNamedObjects: []];
    }
  andSo: function() { 
      [self assert: [betsy, spike, fang]
            equals: [sut.available content]];
    }];
}

@end	
