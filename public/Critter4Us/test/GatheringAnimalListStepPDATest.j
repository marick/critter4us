@import <Critter4Us/page-for-deleting-animals/state-machine/GatheringAnimalListStepPDA.j>
@import "ScenarioTestCase.j"


@implementation GatheringAnimalListStepPDATest : ScenarioTestCase
{
}

- (void) setUp
{
  sut = [GatheringAnimalListStepPDA alloc];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardOutlets: ['animalListController']];
  [scenario sutWillBeGiven: ['master']];
  [scenario sutHasDownwardOutlets: ['persistentStore']]
  [sut initWithMaster: sut.master];
}

- (void) test_does_nothing_when_started
{
  
}

- (void) test_responds_to_user_desire_by_fetching_animal_deletion_data
{
  [scenario
    during: function() { 
      [self sendNotification: UserWantsToDeleteAnimalsNews];
    }
  behold: function() {
      [sut.persistentStore shouldReceive: @selector(fetchAnimalDeletionData)];
    }];
}

@end
