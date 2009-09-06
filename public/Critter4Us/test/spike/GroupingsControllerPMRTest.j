@import <Critter4Us/page-for-making-reservations/GroupingsControllerPMR.j>
@import "ScenarioTestCase.j"

@implementation GroupingsControllerPMRTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[DropTarget alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasSidewaysCollaborators: ['animalController', 'procedureController']];
}

-(void) testInstructsAnimalControllerWhenAnAnimalIsChosen
{
  // TODO: should this be done by AnimalController
  [self assertFalse: YES];
  [scenario
   during: function() {
      [self sendNotification: OneAnimalChosenNews];
    }
   behold: function() {
    }];
}

- (void) testSpillingData
{
  return; // TODO: this test.
  var dict = [CPMutableDictionary dictionary];
  [scenario
    previousAction: function() {
    }
  testAction: function() { 
      [sut spillIt: dict];
    }
  andSo: function() {
      [self assert: ["betty", "delta"]
            equals: [dict objectForKey: "animals"]];
      [self assert: ["procedure"]
            equals: [dict objectForKey: "procedures"]];
    }];
}


@end
