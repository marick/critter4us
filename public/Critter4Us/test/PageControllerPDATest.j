@import <Critter4Us/page-for-deleting-animals/PageControllerPDA.j>
@import "ScenarioTestCase.j"

@implementation PageControllerPDATest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[PageControllerPDA alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];

  [scenario sutHasUpwardOutlets: ['table']];
  [scenario sutHasDownwardOutlets: ['persistentStore']];
}

- (void) test_appearing_fetches_the_latest_version_of_the_reservation_table
{
  [scenario
   during: function() {
     [sut appear];
   }
   behold: function() {
      [sut.persistentStore shouldReceive: @selector(animalTableAsHtml)];
   }];
}


- (void) test_arrival_of_reservation_table_updates_HTML
{
  [scenario
   during: function() {
      [self sendNotification: AnimalTableRetrievedNews
                  withObject: "a string"];
   }
   behold: function() {
      [sut.table shouldReceive: @selector(loadHTMLString:baseURL:)
                          with: ["a string", nil]];
   }];
}

@end
