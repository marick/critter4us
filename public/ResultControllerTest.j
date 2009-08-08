@import "ResultController.j"
@import "ScenarioTestCase.j"

@implementation ResultControllerTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[ResultController alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardCollaborators: ['link', 'containingView']];
}


-(void) testInitialAppearance
{
  [scenario
   whileAwakening: function() {
      [self controlsWillBeMadeHidden];
    }];
}

@end
