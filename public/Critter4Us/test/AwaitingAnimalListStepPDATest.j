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

// EVENT: animals are available to choose from

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

// EVENT: animals have been chosen

- (void) test_sends_animal_list_off_and_transitions_to_starting_state
{
  var chosen = [ [[NamedObject alloc] initWithName: 'fred'], 
                 [[NamedObject alloc] initWithName: 'betsy'] ];

  [scenario 
    during: function() { 
      [self sendNotification: AnimalsToRemoveFromServiceNews
                  withObject: chosen];
    }
  behold: function() {
      [sut.persistentStore shouldReceive: @selector(takeAnimalsOutOfService:)
                                    with: [chosen]];
      [sut.master shouldReceive: @selector(takeStep:)
                           with: AwaitingDateChoiceStepPDA];
    }];
}


@end
