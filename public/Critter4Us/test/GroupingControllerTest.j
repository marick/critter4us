@import <Critter4Us/controller/GroupingController.j>
@import "ScenarioTestCase.j"


@implementation GroupingControllerTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[GroupingController alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardCollaborators: ['window', 'dragTargetView']];
}

-(void) testRegistersWindowToReceiveProceduresAndAnimals
{
  [scenario
   whileAwakening: function() {
      [sut.window shouldReceive: @selector(registerForDraggedTypes:)
                           with: [[ProcedureDragType, AnimalDragType]]];
    }];
}

-(void) testActsAsDelegateForWindow
{
  [scenario
   whileAwakening: function() {
      [sut.window shouldReceive: @selector(setDelegate:)
                           with: sut];
    }];
}

-(void) testSetsWindowColorToNeutralValue
{
  [scenario
   whileAwakening: function() {
      [sut.dragTargetView shouldReceive: @selector(setBackgroundColor:)
                         with: [CPColor whiteColor]];
    }];
}


- (void) testDraggingEnteredHighlightsWindow
{
  [scenario
   during: function() {
      [sut draggingEntered: self];
    }
  behold: function() {
      [sut.dragTargetView shouldReceive: @selector(setBackgroundColor:)
                           with: [CPColor redColor]];
    }];
}

- (void) testDraggingExitedUnHighlightsWindow
{
  [scenario
   during: function() {
      [sut draggingExited: self];
    }
  behold: function() {
      [sut.dragTargetView shouldReceive: @selector(setBackgroundColor:)
                           with: [CPColor whiteColor]];
    }];
}


@end
