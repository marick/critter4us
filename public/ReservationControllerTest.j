@import "ReservationController.j"
@import "ScenarioTestCase.j"
@import "Time.j"


@implementation ReservationControllerTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[ReservationController alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardCollaborators: ['button']];
}


- (void)testButtonClickJustSendsANotification
{
  [scenario
   during: function() {
      [sut makeReservation: 'ignored'];
    }
   behold: function() {
      [self listenersWillReceiveNotification: ReservationRequestedNews];
    }];
}

@end
