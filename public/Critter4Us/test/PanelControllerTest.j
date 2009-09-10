@import <Critter4Us/controller/PanelController.j>
@import "ScenarioTestCase.j"

@implementation PanelControllerTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[PanelController alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardCollaborators: ['panel']]
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
