@import <Critter4Us/page-for-deleting-animals/AnimalsControllerPDA.j>
@import "ScenarioTestCase.j"

@implementation AnimalsControllerPDATest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[AnimalsControllerPDA alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardOutlets: ['availablePanelController', 'availableView', 
                                  'usedPanelController', 'usedView']];
}


- (void) test_panels_are_hidden_initially
{
  [scenario
    whileAwakening: function() {
      [sut.availablePanelController shouldReceive: @selector(disappear)];
      [sut.usedPanelController shouldReceive: @selector(disappear)];
    }];
}

- (void) test_controller_fans_out_appear
{
  [scenario 
    during: function() {
      [sut appear];
    }
  behold: function() {
      [sut.availablePanelController shouldReceive: @selector(appear)];
      [sut.usedPanelController shouldReceive: @selector(appear)];
    }];
}



@end
