@import <Critter4Us/page-for-deleting-animals/state-machine/AwaitingDateChoiceStepPDA.j>
@import <Critter4Us/test/testutil/ScenarioTestCase.j>

@implementation _AwaitingDateChoiceStepPDATest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [AwaitingDateChoiceStepPDA alloc];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutWillBeGiven: ['master']];
  [scenario sutHasUpwardOutlets: ['backgroundController', 'animalsController']]
  [scenario sutHasDownwardOutlets: ['persistentStore']]
  [sut initWithMaster: sut.master];
}

- (void) test_does_nothing_when_started
{
  [scenario 
    during: function() {
      [sut start];
    }
  behold: function() {
      [sut.backgroundController shouldReceive: @selector(allowDateEntry)];
      [sut.animalsController shouldReceive: @selector(disappear)];
    }];
}

- (void) test_asks_for_animal_data_when_user_is_ready_and_resigns
{
  [scenario
    during: function() {
      [self sendNotification: UserWantsAnimalsThatCanBeRemovedFromService
                  withObject: '2009-12-12'];
    }
  behold: function() {
      [sut.persistentStore shouldReceive: @selector(fetchAnimalsInServiceOnDate:)
                                    with: '2009-12-12'];
      [sut.persistentStore shouldReceive: @selector(fetchAnimalsWithPendingReservationsOnDate:)
                                    with: '2009-12-12'];
      [sut.master shouldReceive: @selector(takeStep:)
                           with: AwaitingAnimalListStepPDA];
    }];
}

@end
