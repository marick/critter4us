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
  [scenario sutHasUpwardOutlets: ['animalsController', 'backgroundController']];
  [scenario sutWillBeGiven: ['master']];
  [scenario sutHasDownwardOutlets: ['persistentStore']]
  [sut initWithMaster: sut.master];
}

- (void) test_starting
{
  [scenario 
    during: function() {
      [sut start];
    }
  behold: function() {
      [sut.backgroundController shouldReceive: @selector(forbidDateEntry)];
      [sut.animalsController shouldReceive: @selector(emptyLists)];
      [sut.animalsController shouldReceive: @selector(appear)];
    }];
}

// EVENT: animals are available to choose from

- (void) test_initializes_collection_views
{
  var betsy = [[Animal alloc] initWithName: 'betsy'];
  var dict = [CPDictionary dictionaryWithJSObject: {'unused animals' : [betsy]}];
  [scenario 
    during: function() { 
      [self sendNotification: AnimalsThatCanBeRemovedFromServiceRetrieved
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

// EVENT: A supplementary list of animals UNavailable to choose from is available.

- (void) test_initializes_table_showing_animals_with_pending_reservations
{
  [scenario 
    during: function() { 
      [self sendNotification: TableOfAnimalsWithPendingReservationsNews
                  withObject: "html"];
    }
  behold: function() {
      [sut.backgroundController shouldReceive: @selector(showAnimalsWithPendingReservations:)
                                         with: "html"]
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
      [sut.backgroundController shouldReceive: @selector(effectiveDate)
                                    andReturn: "2009-12-01"];
      [sut.persistentStore shouldReceive: @selector(takeAnimals:outOfServiceOn:)
                                    with: [chosen, '2009-12-01']];
      [sut.master shouldReceive: @selector(takeStep:)
                           with: AwaitingDateChoiceStepPDA];
    }];
}


// EVENT: User wants to restart

- (void) test_restart_transitions_to_initial_state
{
  [scenario 
    during: function() { 
      [self sendNotification: RestartAnimalRemovalStateMachineNews];
    }
  behold: function() {
      [sut.master shouldReceive: @selector(takeStep:)
                           with: AwaitingDateChoiceStepPDA];
    }];
}



@end
