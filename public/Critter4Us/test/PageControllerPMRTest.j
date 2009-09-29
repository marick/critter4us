@import <Critter4Us/page-for-making-reservations/PageControllerPMR.j>
@import "ScenarioTestCase.j"

@implementation PageControllerPMRTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[PageControllerPMR alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];

  [scenario sutHasUpwardCollaborators: ['pageView']];
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
  var panelController1 = [[Mock alloc] initWithName: 'panelController 1'];
  var panelController2 = [[Mock alloc] initWithName: 'panelController 2'];
  [scenario
   previousAction: function() { 
      [sut addPanelControllersFromArray: [panelController1, panelController2]];
    }
  during: function() {
      [sut disappear];
    }
  behold: function() {
      [panelController1 shouldReceive: @selector(hideAnyVisiblePanels)];
      [panelController2 shouldReceive: @selector(hideAnyVisiblePanels)];
   }];
  [self assertTrue: [panelController1 wereExpectationsFulfilled]];
  [self assertTrue: [panelController2 wereExpectationsFulfilled]];
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
  var panelController1 = [[Mock alloc] initWithName: 'panelController 1'];
  var panelController2 = [[Mock alloc] initWithName: 'panelController 2'];
  [scenario
    previousAction: function() {
      [sut addPanelController: panelController1];
      [sut addPanelController: panelController2];
    }
  during: function() {
      [sut appear];
    }
  behold: function() {
      [panelController1 shouldReceive: @selector(showPanelIfAppropriate)];
      [panelController2 shouldReceive: @selector(showPanelIfAppropriate)];
    }];
  [self assertTrue: [panelController1 wereExpectationsFulfilled]];
  [self assertTrue: [panelController2 wereExpectationsFulfilled]];
}



@end
