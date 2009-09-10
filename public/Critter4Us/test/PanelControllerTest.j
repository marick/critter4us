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

@end	
