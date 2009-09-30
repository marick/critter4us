@import <Critter4Us/view/Advisor.j>
@import "ScenarioTestCase.j"

@implementation AdvisorTest : ScenarioTestCase
{
  Advisor sut;
}

- (void) setUp
{
  sut = [[Advisor alloc] init];
  sut.skipStandardConfiguration = YES;
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutCreates: ['panel', 'textField', 'controller']];
}

- (void) testActionsAfterStandardConfiguration
{
  [scenario
    during: function() {
      [self sendNotification: AdviceAboutAnimalsDroppedNews 
                  withObject: "some text"];
    }
  behold: function() { 
      [sut.textField shouldReceive: @selector(setStringValue:) with: "some text"];
      [sut.panel shouldReceive: @selector(setDelegate:) with: sut.controller];
      [sut.controller shouldReceive: @selector(appear)];
      [self listenersShouldReceiveNotification: NewPanelOnPageNews 
                              containingObject: sut.controller];
    }];
}

@end
