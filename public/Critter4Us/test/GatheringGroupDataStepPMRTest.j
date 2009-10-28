@import <Critter4Us/page-for-making-reservations/state-machine/GatheringGroupDataStepPMR.j>
@import "StateMachineTestCase.j"
@import <Critter4Us/model/Animal.j>
@import <Critter4Us/model/Procedure.j>
@import <Critter4Us/util/Time.j>


@implementation GatheringGroupDataStepPMRTest : StateMachineTestCase
{
}

- (void) setUp
{
  sut = [GatheringGroupDataStepPMR alloc];
  [super setUp];
}

- (void) test_start_by_initializing_collaborators
{
  [scenario
    during: function() {
      [sut start];
    }
  behold: function() {
      [sut.reservationDataController shouldReceive:@selector(prepareToFinishReservation)];
      [sut.groupController shouldReceive:@selector(prepareToEditGroups)];
      [sut.procedureController shouldReceive:@selector(appear)];
      [sut.animalController shouldReceive:@selector(appear)];
      [sut.groupController shouldReceive:@selector(appear)];
    }];
}

- (void) test_when_animal_and_procedure_data_appears_pass_it_on_to_controllers
{
  var animal = [[Animal alloc] initWithName: "fred" kind: 'cow'];
  var proc = [[Procedure alloc] initWithName: 'procme'];
  var jsdict = {'animals':[animal], 'procedures':[proc]};
  var dict = [CPDictionary dictionaryWithJSObject: jsdict];
  [scenario
    during: function() {
      [self sendNotification: InitialDataForACourseSessionNews
                  withObject: dict];
    }
  behold: function() {
      [sut.animalController shouldReceive: @selector(allPossibleObjects:)
                                     with: [[animal]]];
      [sut.procedureController shouldReceive: @selector(allPossibleObjects:)
                                     with: [[proc]]];

    }];
}

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
      [sut.master shouldReceive: @selector(nextStep:)
                           with: StoringReservationStepPMR];
    }];
}


@end
