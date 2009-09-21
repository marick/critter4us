@import <Critter4Us/page-for-making-reservations/ProcedureControllerPMR.j>
@import <Critter4US/model/Procedure.j>
@import "ScenarioTestCase.j"

@implementation ProcedureControllerPMRTest : ScenarioTestCase
{
  Procedure floating, milking, dancing;
}

- (void)setUp
{
  sut = [[ProcedureControllerPMR alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardCollaborators: ['available', 'used']];

  floating = [[Procedure alloc] initWithName: 'floating'];
  milking = [[Procedure alloc] initWithName: 'milking'];
  dancing = [[Procedure alloc] initWithName: 'dancing'];
}


- (void) testSpillingData
{
  var dict = [CPMutableDictionary dictionary];
  [scenario
  previousAction: function() {
      [sut allPossibleObjects: [floating, milking, dancing]];
      [sut presetUsed: [floating, milking, dancing]];
    }
  testAction: function() { 
      [sut spillIt: dict];

    }
  andSo: function() {
      [self assert: ["floating", "milking", "dancing"]
            equals: [dict objectForKey: "procedures"]];
    }];
}


@end	
