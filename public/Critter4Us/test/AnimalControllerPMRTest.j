@import <Critter4Us/page-for-making-reservations/AnimalControllerPMR.j>
@import <Critter4US/model/Animal.j>
@import "ScenarioTestCase.j"

@implementation AnimalControllerPMRTest : ScenarioTestCase
{
  Animal fred, betty, dave;
}

- (void)setUp
{
  sut = [[AnimalControllerPMR alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardCollaborators: ['available', 'used']];

  fred = [[Animal alloc] initWithName: 'fred' kind: 'cow'];
  betty = [[Animal alloc] initWithName: 'betty' kind: 'cow'];
  dave = [[Animal alloc] initWithName: 'dave' kind: 'horse'];
}


-(void) testBeginning
{
  [scenario 
    during: function() {
      [sut allPossibleObjects: [betty, dave, fred]];
    }
    behold: function() { 
      [sut.available shouldReceive: @selector(setNeedsDisplay:) with: YES];
      [sut.used shouldReceive: @selector(setNeedsDisplay:) with: YES];
    }
    andSo: function() {
      [self assert: [betty, dave, fred]
            equals: [sut.available content]];
      [self assert: []
            equals: [sut.used content]];
    }];
}

- (void)testWithholdingAnimalsLeavesThemOutOfAvailableList
{
  [scenario
   previousAction: function() {
      [sut allPossibleObjects: [betty, dave, fred]];
    }
  during: function() { 
      [sut withholdAnimals: [fred, betty]];
    }
  behold: function() {
      [sut.available shouldReceive: @selector(setNeedsDisplay:) with: YES];
    }
  andSo: function() {
      [self assert: [dave]
            equals: [sut.available content]];
    }];
}

- (void)testWithholdingAnimalsNeedNotBePermanent
{
  [scenario
   previousAction: function() { 
      [sut allPossibleObjects: [betty, dave, fred]];
      [sut withholdAnimals: [fred, betty]];
    }
  testAction: function() { 
      [sut withholdAnimals: []];
    }
  andSo: function() { 
      [self assert: [betty, dave, fred]
            equals: [sut.available content]];
    }];
}

- (void) testWithholdingAppliesToChosenAnimalsAsWell
{
  [scenario
  previousAction: function() {
      [sut allPossibleObjects: [betty, dave, fred]];
      [self simulateChoiceOf: [dave,fred]];
      [self assert: [betty] equals: [sut.available content]];
      [self assert: [dave, fred] equals: [sut.used content]];
    }
  testAction: function() { 
      [sut withholdAnimals: [betty, fred]];
    }
  andSo: function() {
      [self assert: [] equals: [sut.available content]];
      [self assert: [dave] equals: [sut.used content]];
    }];
}

- (void) testWithholdingAnAnimalDoes_Not_RechooseItIfItReappears
{
  [scenario
  previousAction: function() {
      [sut allPossibleObjects: [betty, dave, fred]];
      [self simulateChoiceOf: [dave, fred]];
      [sut withholdAnimals: [betty, fred]];
      [self assert: [] equals: [sut.available content]];
      [self assert: [dave] equals: [sut.used content]];
    }
  testAction: function() { 
      [sut withholdAnimals: []];
    }
  andSo: function() {
      [self assert: [betty, fred] equals: [sut.available content]];
      [self assert: [dave] equals: [sut.used content]];
    }];
}

- (void) testSpillingData
{
  var dict = [CPMutableDictionary dictionary];
  [scenario
  previousAction: function() {
      [sut allPossibleObjects: [betty, dave, fred]];
      [self simulateChoiceOf: [dave, fred]];
    }
  testAction: function() { 
      [sut spillIt: dict];

    }
  andSo: function() {
      [self assert: ["dave", "fred"]
            equals: [dict objectForKey: "animals"]];
    }];
}



-(void) simulateChoiceOf: animals
{
  var copy = [[sut.available content] copy];
  [copy removeObjectsInArray: animals];
  [sut.available setContent: copy];
  [sut.used setContent: animals];
}




@end	
