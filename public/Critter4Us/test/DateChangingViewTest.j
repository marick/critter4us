@import <Critter4Us/view/DateChangingView.j>
@import "ScenarioTestCase.j"

@implementation DateChangingViewTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[DateChangingView alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
}

-(void) testAppear
{
  [scenario
    during: function() {
    }
  behold: function() {
   }];
}

@end	
