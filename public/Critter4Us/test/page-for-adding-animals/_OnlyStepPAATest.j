@import <Critter4Us/page-for-adding-animals/state-machine/OnlyStepPAA.j>
@import <Critter4Us/test/testutil/ScenarioTestCase.j>

@implementation _OnlyStepPAATest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [OnlyStepPAA alloc];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasDownwardOutlets: ['persistentStore']]
  [sut initWithMaster: sut.master];
}

- (void) test_pushes_data_to_persistent_store
{
  [scenario
    during: function() {
      [self sendNotification: UserWantsToAddAnimals
                  withObject: ["animal descriptions"]];
    }
  behold: function() {
      [sut.persistentStore shouldReceive: @selector(addAnimals:)
                                    with: [["animal descriptions"]]];
    }];
}

@end
