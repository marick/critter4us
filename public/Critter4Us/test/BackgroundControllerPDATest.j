@import <Critter4Us/page-for-deleting-animals/BackgroundControllerPDA.j>
@import "ScenarioTestCase.j"

@implementation BackgroundControllerPDATest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[BackgroundControllerPDA alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardOutlets: ['dateField']];
}

- (void)testNotifiesListenersWhenDateChosen
{
  [scenario
    previousAction: function() {
      [sut.dateField setStringValue: '2009-12-10'];
    }
    during: function() {
      [sut animalsInServiceForDate: UnusedArgument];
    }
  behold: function() {
      [self listenersWillReceiveNotification: UserWantsAnimalsInServiceOnDateNews
                            containingObject: '2009-12-10'];
        }];
    }
   ]   
}


@end
