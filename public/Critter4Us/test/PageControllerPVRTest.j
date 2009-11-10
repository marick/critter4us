@import <Critter4Us/page-for-viewing-reservations/PageControllerPVR.j>
@import "ScenarioTestCase.j"

@implementation PageControllerPVRTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[PageControllerPVR alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];

  [scenario sutHasDownwardOutlets: ['persistentStore']];
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


@end
