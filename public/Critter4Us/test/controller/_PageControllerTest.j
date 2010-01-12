@import <Critter4Us/controller/PageController.j>
@import <Critter4Us/test/testutil/ScenarioTestCase.j>

@implementation _PageControllerTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[PageController alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];

  [scenario sutHasUpwardOutlets: ['pageView']];
  [scenario sutWillBeGiven: ['panelController1', 'panelController2']];
}

-(void) test_appearing_unhides_page_view
{
  [scenario
   previously: function() { 
     [sut.pageView setHidden: YES];
   }
   testAction: function() {
     [sut appear];
   }
   andSo: function() {
     [self assertFalse: [sut.pageView hidden]];
   }];
}

-(void) test_appearing_shows_any_panels_that_are_ready_to_be_shown
{
  [scenario
    previously: function() {
      [sut addPanelController: sut.panelController1];
      [sut addPanelController: sut.panelController2];
    }
  during: function() {
      [sut appear];
    }
  behold: function() {
      [sut.panelController1 shouldReceive: @selector(showPanelIfAppropriate)];
      [sut.panelController2 shouldReceive: @selector(showPanelIfAppropriate)];
    }];
}




-(void) test_disappearing_hides_page_view
{
  [scenario
   previously: function() { 
     [sut.pageView setHidden: NO];
   }
   testAction: function() {
     [sut disappear];
   }
   andSo: function() {
     [self assertTrue: [sut.pageView hidden]];
   }];
}

-(void) test_disappearing_hides_any_panels_attached_to_page
{
  [scenario
   previously: function() { 
      [sut addPanelControllersFromArray: [sut.panelController1, sut.panelController2]];
    }
  during: function() {
      [sut disappear];
    }
  behold: function() {
      [sut.panelController1 shouldReceive: @selector(hideAnyVisiblePanels)];
      [sut.panelController2 shouldReceive: @selector(hideAnyVisiblePanels)];
   }];
}

@end
