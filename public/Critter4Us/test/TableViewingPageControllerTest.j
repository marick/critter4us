@import <Critter4Us/controller/TableViewingPageController.j>
@import "ScenarioTestCase.j"

@implementation TableViewingPageControllerTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[TableViewingPageController alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];

  [scenario sutHasUpwardOutlets: ['pageView', 'table']];
}

-(void) testAppearingMeansBecomingUnhidden
{
  [scenario
   previousAction: function() { 
     [sut.pageView setHidden:NO];
   }
   testAction: function() {
     [sut appear];
   }
   andSo: function() {
     [self assertFalse: [sut.pageView hidden]];
   }];
}

-(void) testDisappearingMeansBecomingHidden
{
  [scenario
   previousAction: function() { 
     [sut.pageView setHidden:YES];
   }
   testAction: function() {
     [sut disappear];
   }
   andSo: function() {
     [self assertTrue: [sut.pageView hidden]];
   }];
}
@end
