@import <Critter4Us/page-for-making-reservations/PageControllerPMR.j>
@import "ScenarioTestCase.j"

@implementation PageControllerPMRTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[PageControllerPMR alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];

  [scenario sutHasUpwardCollaborators:
              ['pageView']];
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


@end
