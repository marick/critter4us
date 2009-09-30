@import <Critter4Us/controller/PanelController.j>
@import "ScenarioTestCase.j"

@implementation PanelControllerTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [PanelController alloc];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutWillBeGiven: ['panel']];
  [sut initWithPanel: sut.panel];
}

- (void) testWhenHandedPanelIssuesNotification
{
  [scenario
    during: function() {
      [sut initWithPanel: sut.panel];
    }
  behold: function() { 
      [self listenersWillReceiveNotification: NewPanelOnPageNews
                            containingObject: sut];
    }];
}

- (void) testNotifiesWhenPanelCloses
{
  // This is peculiar, but cappuccino sends windowWillClose on orderOut. That seems
  // consistent with Cocoa, odd though it may be. So this is the way to distinguish 
  // between "go away forever" and "disappear for now".
  [scenario
    during: function() {
      return [sut windowShouldClose: UnusedArgument];
    }
  behold: function() { 
      [self listenersWillReceiveNotification: ClosedPanelOnPageNews
                            containingObject: sut];
    }
  andSo: function() {
      [self assertTrue: scenario.result];
    }];
}

-(void) testAppear
{
  [scenario
    during: function() {
      [sut appear];
    }
  behold: function() {
      [sut.panel shouldReceive: @selector(orderFront:)];
   }];
}

-(void) testDisappear
{
  [scenario
    during: function() {
      [sut disappear];
    }
  behold: function() {
      [sut.panel shouldReceive: @selector(orderOut:)];
   }];
}

-(void) testPanelControllersCanHidePanelsTheyAreShowing
{
  [scenario
    during: function() {
      [sut hideAnyVisiblePanels];
    }
  behold: function() {
      [sut.panel shouldReceive: @selector(orderOut:)];
   }];
}

-(void) testPanelControllerKnowsItsNotAppropriateToBeVisibleWhenCreated
{
  [scenario
    during: function() {
      [sut showPanelIfAppropriate];
    }
  behold: function() {
      [sut.panel shouldReceive: @selector(orderOut:)];
    }];
}

-(void) testPanelShouldReappearAfterBeingHiddenIfItWasAlreadyShowing
{
  [scenario
    previousAction: function() {
      [sut appear];
      [sut hideAnyVisiblePanels];
    }
  during: function() {
      [sut showPanelIfAppropriate];
    }
  behold: function() {
      [sut.panel shouldReceive: @selector(orderFront:)];
    }];
}

-(void) testPanelShouldNotReappearAfterBeingHiddenIfItWasNotAlreadyShowing
{
  [scenario
    previousAction: function() {
      [sut appear]
      [sut disappear];
      [sut hideAnyVisiblePanels];
    }
  during: function() {
      [sut showPanelIfAppropriate];
    }
  behold: function() {
      [sut.panel shouldReceive: @selector(orderOut:)];
    }];
}

@end	
