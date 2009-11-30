@import <Critter4Us/page-for-deleting-animals/state-machine/AwaitingAnimalListStepPDA.j>
@import <Critter4Us/model/Animal.j>
@import "ScenarioTestCase.j"


@implementation AwaitingAnimalListStepPDATest : ScenarioTestCase
{
}

- (void) setUp
{
  sut = [AwaitingAnimalListStepPDA alloc];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardOutlets: ['animalsController']];
  [scenario sutWillBeGiven: ['master']];
  [scenario sutHasDownwardOutlets: ['persistentStore']]
  [sut initWithMaster: sut.master];
}

- (void) test_does_nothing_when_started
{
}

// EVENT: animals are available

- (void) test_makes_panels_appear_when_notified
{
  var dict = [CPDictionary dictionaryWithJSObject: {'unused animals' : []}];
  [scenario 
    during: function() { 
      [self sendNotification: AnimalInServiceListRetrievedNews
                  withObject: dict];
    }
  behold: function() {
      [sut.animalsController shouldReceive: @selector(appear)];
    }];
}

- (void) test_initializes_collection_views
{
  var betsy = [[Animal alloc] initWithName: 'betsy'];
  var dict = [CPDictionary dictionaryWithJSObject: {'unused animals' : [betsy]}];
  [scenario 
    during: function() { 
      [self sendNotification: AnimalInServiceListRetrievedNews
                  withObject: dict];
    }
  behold: function() {
      [sut.animalsController shouldReceive: @selector(allPossibleObjects:)
                                      with: function(arg) { 
          [self assert: 'betsy' equals: [arg[0] name]];
          return YES;
        }];
    }];
}

@end
