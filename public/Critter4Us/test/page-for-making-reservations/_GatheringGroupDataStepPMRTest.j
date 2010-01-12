@import <Critter4Us/page-for-making-reservations/state-machine/DateChangingGroupDataStepPMR.j>
@import <Critter4Us/page-for-making-reservations/state-machine/GatheringGroupDataStepPMR.j>
@import <Critter4Us/test/testutil/ScenarioTestCase.j>
@import <Critter4Us/model/Animal.j>
@import <Critter4Us/model/Procedure.j>
@import <Critter4Us/model/Group.j>
@import <Critter4Us/util/Time.j>


@implementation _GatheringGroupDataStepPMRTest : ScenarioTestCase
{
  Animal betsy;
  Animal jake;
  Animal fang;
  Procedure floating;
  Procedure radiology;

  Group someGroup;
}

- (void) setUp
{
  sut = [GatheringGroupDataStepPMR alloc];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutWillBeGiven: ['reservationDataController', 'animalController', 'procedureController', 'groupController', 'currentGroupPanelController', 'persistentStore', 'master']];
  [sut initWithMaster: sut.master];

  betsy = [[Animal alloc] initWithName: 'betsy' kind: 'cow'];
  jake = [[Animal alloc] initWithName: 'jake' kind: 'horse'];
  jake = [[Animal alloc] initWithName: 'fang' kind: 'dog'];
  floating = [[Procedure alloc] initWithName: 'floating'];
  radiology = [[Procedure alloc] initWithName: 'radiology'];

  someGroup = [[Group alloc] initWithProcedures: [floating, radiology]
                                        animals: [jake, betsy]];
}

// At the beginning: The time and date and all that have been selected

- (void) test_start_by_initializing_collaborators
{
  [scenario
    during: function() {
      [sut start];
    }
  behold: function() {
      [sut.reservationDataController shouldReceive:@selector(prepareToFinishReservation)];
      [sut.procedureController shouldReceive:@selector(appear)];
      [sut.animalController shouldReceive:@selector(appear)];
      [sut.currentGroupPanelController shouldReceive:@selector(appear)];
      [sut.groupController shouldReceive: @selector(showGroupButtons)];
      [sut.groupController shouldReceive: @selector(addEmptyGroupToCollection)];
    }];
}

// EVENT: The server tells us about animals and procedures for a given date

// Note: this may be called multiple times per reservation (if time/date changed).
- (void) test_when_animal_and_procedure_data_appears_pass_it_on_to_controllers
{
  var jsdict = {'animals':['animals...'], 'procedures':['procedures...']};
  var dict = [CPDictionary dictionaryWithJSObject: jsdict];
  [scenario
    during: function() {
      [self sendNotification: AnimalAndProcedureNews
                  withObject: dict];
    }
  behold: function() {
      [sut.animalController shouldReceive: @selector(allPossibleObjects:)
                                     with: [['animals...']]];
      [sut.procedureController shouldReceive: @selector(allPossibleObjects:)
                                     with: [['procedures...']]];
    }];
}

// EVENT: The server tells us about a reservation (+ animal, procedure, reservation data)

- (void) test_when_new_reservation_appears_pass_it_on_to_controllers
{
  var jsdict = {'animals':['animals...'], 'procedures':['procedures...'],
                'groups':['groups...'], 'reservation data...':['...']};
  var dict = [CPDictionary dictionaryWithJSObject: jsdict];
  [scenario
    during: function() {
      [self sendNotification: ReservationRetrievedNews
                  withObject: dict];
    }
  behold: function() {
      [sut.reservationDataController shouldReceive: @selector(setNewValuesFrom:)
                                              with: dict];
      [sut.animalController shouldReceive: @selector(allPossibleObjects:)
                                     with: [['animals...']]];
      [sut.procedureController shouldReceive: @selector(allPossibleObjects:)
                                        with: [['procedures...']]];
      [sut.groupController shouldReceive: @selector(allPossibleObjects:)
                                    with: [['groups...']]];
      [sut.groupController shouldReceive: @selector(redisplayInLightOf:)
                                    with: [['procedures...']]];
    }];
}


// EVENT: A user chooses an animal or procedure

-(void)test_when_procedures_change_the_animal_controller_is_told_to_update
{
  var radiology = [[Procedure alloc] initWithName: 'radiology' excluding: [betsy]];
  var floating = [[Procedure alloc] initWithName: 'floating'   excluding: [fang]];
  var userInfo = [CPDictionary dictionaryWithJSObject: {'used': [radiology, floating]}];
  [scenario
   during: function() {
      [self sendNotification: DifferentObjectsUsedNews
                  withObject: sut.procedureController
                    userInfo: userInfo];
    }
   behold: function() {
      [sut.animalController shouldReceive:@selector(withholdNamedObjects:)
                                     with: [[betsy, fang]]];
      // ... but there's more...
    }];
}

-(void)test_when_either_source_controller_changes_those_changes_propagate_to_the_group_controller
{
  [scenario
   during: function() {
      [self sendNotification: DifferentObjectsUsedNews];
    }
   behold: function() {
      [sut.animalController shouldReceive:@selector(usedObjects)
                                andReturn: [betsy]];
      [sut.procedureController shouldReceive: @selector(usedObjects)
                                   andReturn: [floating]];
      [sut.groupController shouldReceive:@selector(setCurrentGroupProcedures:animals:)
                                    with: [[floating], [betsy]]];
    }];
}

// EVENT: The user chooses a new group to work on

-(void)test_switching_to_a_new_group_resets_both_controllers_with_new_available_objects
{
  [scenario
   during: function() {
      [self sendNotification: SwitchToGroupNews
                  withObject: someGroup];
    }
   behold: function() {
      [sut.animalController shouldReceive:@selector(presetUsed:)
                                     with: [[someGroup animals]]];
      [sut.procedureController shouldReceive:@selector(presetUsed:)
                                        with: [[someGroup procedures]]];
      // ...
    }];
}

-(void)test_switching_to_a_new_group_filters_new_animals_according_to_new_procedures
{
  var animals = [ [[Animal alloc] initWithName: 'animal0' kind: 'cow'],
                  [[Animal alloc] initWithName: 'animal1' kind: 'horse'],
                  [[Animal alloc] initWithName: 'animal2' kind: 'horse']];

  var procedures = [ [[Procedure alloc] initWithName: 'procedure0'
                                           excluding: [animals[0]]],
                     [[Procedure alloc] initWithName: 'procedure1'
                                           excluding: []]];

  var group = [[Group alloc] initWithProcedures: procedures animals: animals];
  [scenario
   during: function() {
      [self sendNotification: SwitchToGroupNews
                  withObject: group];
    }
   behold: function() {
      [sut.animalController shouldReceive:@selector(withholdNamedObjects:)
                                     with: [[animals[0]]]];
    }];
}

                        // Events that result in a new state

// EVENT: The user chooses to finish the reservation

-(void) test_finished_reservation_and_group_data_are_handed_to_persistent_store
{
  [scenario
   during: function() {
      [self sendNotification: TimeToReserveNews];
    }
   behold: function() {
      var dict = [CPDictionary dictionaryWithJSObject: {'course':'and other data too'}];
      [sut.reservationDataController shouldReceive: @selector(data)
                                         andReturn: dict];
      [sut.groupController shouldReceive: @selector(groups)
                               andReturn: 'some group data'];

      [sut.persistentStore shouldReceive: @selector(makeReservation:)
                                    with: function(dict) {
                                        [self assert: 'and other data too'
                                              equals: [dict valueForKey: 'course']
                                             message: "wrong " + [dict description]];
                                        [self assert: 'some group data'
                                              equals: [dict valueForKey: 'groups']
                                             message: "wrong " + [dict description]];
                                        return YES;
        }];
      [sut.master shouldReceive: @selector(takeStep:)
                           with: StoringReservationStepPMR];
    }];
}


- (void) test_selecting_a_new_date_and_time_starts_over
{
  var dict = [CPDictionary dictionary];
  [dict setValue: '2009-02-02' forKey: 'date'];
  [dict setValue: [Time morning] forKey: 'time'];

  [scenario
   during: function() {
      [self sendNotification: DateTimeForCurrentReservationChangedNews
                  withObject: dict];
    }
   behold: function() {
      [sut.persistentStore shouldReceive: @selector(loadInfoRelevantToDate:time:)
                                    with: ['2009-02-02', [Time morning]]];

    }];
}

@end
