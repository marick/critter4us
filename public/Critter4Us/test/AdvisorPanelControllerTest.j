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

- (void) test_when_initialized_issues_notification
{
  [scenario
    during: function() {
      [sut initWithPanel: sut.panel];
    }
  behold: function() { 
      [self listenersWillReceiveNotification: NewAdvisorPanelOnPageNews
                            containingObject: sut];
    }];
}


- (void) test_that_window_is_closed_when_panel_becomes_irrelevant
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

- (void) test_sends_notification_when_closed
{
  // It's odd to test by sending the windowShouldClose delegate
  // method, but cappuccino/cocoa sends windowWillClose on
  // orderOut. So this is the way to distinguish between "go away
  // forever" and "disappear for now".
  [scenario
    during: function() {
      return [sut windowShouldClose: UnusedArgument];
    }
  behold: function() { 
      [self listenersWillReceiveNotification: ClosedAdvisorPanelOnPageNews
                            containingObject: sut];
    }
  andSo: function() {
      [self assertTrue: scenario.result];
    }];
}

@end
