@import <Critter4Us/controller/AllReservationsPageController.j>
@import "ScenarioTestCase.j"

@implementation AllReservationsPageControllerTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[AllReservationsPageController alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];

  [scenario sutHasUpwardCollaborators: ['pageView', 'table']];
  [scenario sutHasDownwardCollaborators: ['persistentStore']];
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

- (void) testAppearingMeansDisplayingAFreshlyFetchedTable
{
  [scenario
   during: function() {
     [sut appear];
   }
   behold: function() {
      [sut.persistentStore shouldReceive: @selector(pendingReservationTableAsHtml)
                               andReturn: "<p>html</p>"];
      [sut.table shouldReceive: @selector(loadHTMLString:baseURL:)
                          with: ["<p>html</p>", nil]];
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