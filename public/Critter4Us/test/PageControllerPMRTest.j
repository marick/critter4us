@import <Critter4Us/page-for-making-reservations/PageControllerPMR.j>
@import "ScenarioTestCase.j"

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


-(void) testDisappearingHidesPage
{
  [scenario
   previousAction: function() { 
     [sut.pageView setHidden:NO];
   }
  testAction: function() {
      [sut disappear];
   }
  andSo: function() {
      [self assertTrue: [sut.pageView hidden]];
   }];
}


-(void) testDisappearingTellsControllersToHideAnyPanelsTheyAreShowing
{
  [scenario
   previousAction: function() { 
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

-(void) testAppearingUnhidesPage
{
  [scenario
   previousAction: function() { 
     [sut.pageView setHidden:YES];
   }
  testAction: function() {
      [sut appear];
   }
  andSo: function() {
     [self assertFalse: [sut.pageView hidden]];
   }];
}

-(void) testAppearingTellsControllersToDisplayTheirPanelIfAppropriate
{
  [scenario
    previousAction: function() {
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

-(void) testNotificationsCanAddPanelControllers
{
  [scenario
    previousAction: function() { 
      [scenario sutWillBeGiven: ['newPanelController']];
      [self sendNotification: NewPanelOnPageNews
                  withObject: sut.newPanelController];
    }
  during: function() {
      [sut disappear];
    }
  behold: function() {
      [sut.newPanelController shouldReceive: @selector(hideAnyVisiblePanels)];
   }];
}


@end
