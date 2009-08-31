@import <Critter4Us/controller/GroupingController.j>
@import "ScenarioTestCase.j"


@implementation GroupingControllerTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[GroupingController alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardCollaborators: ["window"]];
}

-(void) testInitialBehavior
{
  [scenario
   whileAwakening: function() {
      [sut.window shouldReceive: @selector(registerForDraggedTypes:)
                                   with: [[ProcedureDragType, AnimalDragType]]];
    }];
}
@end
