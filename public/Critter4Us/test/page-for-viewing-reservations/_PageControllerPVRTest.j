@import <Critter4Us/page-for-viewing-reservations/PageControllerPVR.j>
@import <Critter4Us/test/testutil/ScenarioTestCase.j>

@implementation _PageControllerPVRTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[PageControllerPVR alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];

  [scenario sutHasUpwardOutlets: ['table', 'daySelection']];
  [scenario sutHasDownwardOutlets: ['persistentStore']];
}


- (void) test_appearing_fetches_the_latest_version_of_the_reservation_table
{
  [scenario
   during: function() {
     [sut appear];
   }
   behold: function() {
      [sut.daySelection shouldReceive: @selector(titleOfSelectedItem)
			    andReturn: "30"];
      [sut.persistentStore shouldReceive: @selector(allReservationsHtmlForPastDays:)
				    with: "30"];
   }];
}

- (void) test_popup_change_fetches_the_latest_version_of_the_reservation_table
{
  [scenario
   during: function() {
      [sut changeDays: "ignored sender"];
   }
   behold: function() {
      [sut.daySelection shouldReceive: @selector(titleOfSelectedItem)
			    andReturn: "60"];
      [sut.persistentStore shouldReceive: @selector(allReservationsHtmlForPastDays:)
				    with: "60"];
   }];
}


- (void) test_arrival_of_reservation_table_updates_HTML
{
  [scenario
   during: function() {
      [self sendNotification: AllReservationsHtmlNews
                  withObject: "a string"];
   }
   behold: function() {
      [sut.table shouldReceive: @selector(loadHTMLString:baseURL:)
                          with: ["a string", nil]];
   }];
}


@end
