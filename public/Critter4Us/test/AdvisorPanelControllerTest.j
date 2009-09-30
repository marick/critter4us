@import <Critter4Us/controller/AdvisorPanelController.j>
@import "ScenarioTestCase.j"

@implementation AdvisorPanelControllerTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [AdvisorPanelController alloc];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutWillBeGiven: ['panel']];
  [sut initWithPanel: sut.panel];
}

- (void) testThatTheWindowIsClosedWhenAdvisoriesBecomeIrrelevant
{
  [scenario
   during: function() {
      [self sendNotification: AdvisoriesAreIrrelevantNews];
    }
  behold: function() {
      [sut.panel shouldReceive: @selector(performClose:)
                          with: sut];
    }];
}

@end
