@import <Critter4Us/page-for-deleting-animals/AnimalsControllerPDA.j>
@import "ScenarioTestCase.j"

@implementation AnimalsControllerPDATest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[AnimalsControllerPDA alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardOutlets: ['availablePanelController', 'available', 
                                  'usedPanelController', 'used',
                                  'submitButton']];
}


- (void) test_panels_are_hidden_initially
{
  [scenario
    whileAwakening: function() {
      [sut.availablePanelController shouldReceive: @selector(disappear)];
      [sut.usedPanelController shouldReceive: @selector(disappear)];
    }];
}

- (void) test_controller_fans_out_appear_and_shows_button
{
  [scenario 
    during: function() {
      [sut appear];
    }
  behold: function() {
      [sut.availablePanelController shouldReceive: @selector(appear)];
      [sut.usedPanelController shouldReceive: @selector(appear)];
      [sut.submitButton shouldReceive: @selector(setHidden:) with: NO];
    }];
}

- (void) test_controller_fans_out_disappear_and_hides_button
{
  [scenario 
    during: function() {
      [sut disappear];
    }
  behold: function() {
      [sut.availablePanelController shouldReceive: @selector(disappear)];
      [sut.usedPanelController shouldReceive: @selector(disappear)];
      [sut.submitButton shouldReceive: @selector(setHidden:) with: YES];
    }];
}

- (void) test_controller_posts_notification_when_submit_button_pressed
{
  var chosen = [ [[NamedObject alloc] initWithName: 'fred'], 
                 [[NamedObject alloc] initWithName: 'betsy'] ];
                                             
                                      
  [scenario 
    during: function() {
      [sut removeAnimalsFromService: UnusedArgument];
    }
  behold: function() {
      [sut.used shouldReceive: @selector(content) 
                        andReturn: chosen];
      [self listenersShouldReceiveNotification: AnimalsToRemoveFromServiceNews
                              containingObject: chosen];
    }];
}

@end
