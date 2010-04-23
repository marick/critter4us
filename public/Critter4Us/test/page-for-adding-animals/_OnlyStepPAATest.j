@import <Critter4Us/page-for-adding-animals/state-machine/OnlyStepPAA.j>
@import <Critter4Us/test/testutil/ScenarioTestCase.j>
@import <Critter4Us/test/testutil/TestUtil.j>

@implementation _OnlyStepPAATest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [OnlyStepPAA alloc];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasDownwardOutlets: ['persistentStore']]
  [scenario sutHasUpwardOutlets: ['backgroundController']]
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


- (void) test_tells_controller_to_reset_when_animals_come_back
{
  [scenario
    during: function() {
      [self sendNotification: UserHasAddedAnimals
                  withObject: cpdict({'duplicates' : ["animal descriptions"]})];
    }
  behold: function() {
      [sut.backgroundController shouldReceive: @selector(clearForFurtherAdditions)];
      [sut.backgroundController shouldReceive: @selector(populatePageWithAnimals:)
					 with: [["animal descriptions"]]];
    }];
}


- (void) test_tells_controller_to_describe_failure_when_duplicates
{
  [scenario
    during: function() {
      [self sendNotification: UserHasAddedAnimals
                  withObject: cpdict({'duplicates' : ["animal descriptions"]})];
    }
  behold: function() {
      [sut.backgroundController shouldReceive: @selector(describeFailure:)
					 with: 1];
    }];
}

- (void) test_tells_controller_to_describe_success_when_no_duplicates
{
  [scenario
    during: function() {
      [self sendNotification: UserHasAddedAnimals
                  withObject: cpdict({'duplicates' : []})];
    }
  behold: function() {
      [sut.backgroundController shouldReceive: @selector(describeSuccess)];
    }];
}




@end
