@import <Critter4Us/view/Advisor.j>
@import "ScenarioTestCase.j"

@implementation AdvisorTest : ScenarioTestCase
{
  Advisor sut;
}

- (void) setUp
{
  sut = [[Advisor alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutCreates: ['panel', 'textField', 'controller']];
}

- (void) testReceiptOfAdviceNotificationProducesPanelAndItsController
{
  [scenario
    during: function() {
      [self sendNotification: AdviceAboutAnimalsDroppedNews
                        withObject: "some text"];
    }
  behold: function() { 
      [sut.panel shouldReceive: @selector(setDelegate) with: sut.controller];
    }];
}


@end
