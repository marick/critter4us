@import <Critter4Us/page-for-making-reservations/state-machine/DateChangingGroupDataStepPMR.j>
@import <Critter4Us/model/Animal.j>
@import <Critter4Us/model/Procedure.j>
@import <Critter4Us/model/Group.j>
@import <Critter4Us/util/Time.j>
@import "ScenarioTestCase.j"


@implementation DateChangingGroupDataStepPMRTest : ScenarioTestCase
{
}

- (void) setUp
{
  sut = [DateChangingGroupDataStepPMR alloc];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutWillBeGiven: ['reservationDataController', 'animalController', 'procedureController', 'groupController', 'currentGroupPanelController', 'persistentStore', 'master']];
  [sut initWithMaster: sut.master];
}


// EVENT: The server tells us about a reservation (+ animal, procedure, reservation data)
// The time, however, is incorrect, so it needs to be changed first thing.
// That will (perhaps) change the animals, procedures, groups, but they're displayed
// anyway to help the user establish context.

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
      [sut.reservationDataController shouldReceive: @selector(startDestructivelyEditingDateTime:)];
      [sut.animalController shouldReceive: @selector(allPossibleObjects:)
                                     with: [['animals...']]];
      [sut.procedureController shouldReceive: @selector(allPossibleObjects:)
                                        with: [['procedures...']]];
      [sut.groupController shouldReceive: @selector(allPossibleObjects:)
                                    with: [['groups...']]];
    }];
}


@end
