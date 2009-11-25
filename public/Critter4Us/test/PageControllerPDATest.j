@import <Critter4Us/page-for-deleting-animals/PageControllerPDA.j>
@import "ScenarioTestCase.j"

@implementation PageControllerPDATest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[PageControllerPDA alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
}


- (void) test_appearing_tells_state_machine_user_wants_deletion_data
{
  [scenario
   during: function() {
     [sut appear];
   }
   behold: function() {
      [self listenersShouldReceiveNotification: UserWantsToDeleteAnimalsNews];
   }];
}


@end
