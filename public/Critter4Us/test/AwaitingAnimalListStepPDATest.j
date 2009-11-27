@import <Critter4Us/page-for-deleting-animals/state-machine/AwaitingAnimalListStepPDA.j>
@import "ScenarioTestCase.j"


@implementation AwaitingAnimalListStepPDATest : ScenarioTestCase
{
}

- (void) setUp
{
  sut = [AwaitingAnimalListStepPDA alloc];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardOutlets: ['animalListController']];
  [scenario sutWillBeGiven: ['master']];
  [scenario sutHasDownwardOutlets: ['persistentStore']]
  [sut initWithMaster: sut.master];
}

- (void) test_does_nothing_when_started
{
  
}

@end
