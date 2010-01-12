@import <Critter4Us/page-for-making-reservations/PageControllerPMR.j>
@import <Critter4Us/test/testutil/ScenarioTestCase.j>

@implementation PageControllerPMRTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[PageControllerPMR alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];

  [scenario sutHasUpwardOutlets: ['pageView']];
  [scenario sutWillBeGiven: ['panelController1', 'panelController2']];
}

-(void) testNotificationsCanAddPanelControllers
{
  [scenario
    previously: function() { 
      [scenario sutWillBeGiven: ['newPanelController']];
      [self sendNotification: NewAdvisorPanelOnPageNews
                  withObject: sut.newPanelController];
    }
  during: function() {
      [sut disappear];
    }
  behold: function() {
      [sut.newPanelController shouldReceive: @selector(hideAnyVisiblePanels)];
   }];
}

-(void) testNotificationsCanRemovePanelControllers
{
  [scenario
    previously: function() { 
      [sut addPanelControllersFromArray: [sut.panelController1, sut.panelController2]];
      [self sendNotification: ClosedAdvisorPanelOnPageNews
                  withObject: sut.panelController2];
    }
  during: function() {
      [sut.panelController2.failOnUnexpectedSelector = YES];
      [sut disappear];
    }
  behold: function() {
      [sut.panelController1 shouldReceive: @selector(hideAnyVisiblePanels)];
   }];
}


@end
