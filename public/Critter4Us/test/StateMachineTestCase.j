@import "ScenarioTestCase.j"


@implementation StateMachineTestCase : ScenarioTestCase
{
}

- (void) setUp
{
  [super setUp];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutWillBeGiven: ['reservationDataController', 'animalController', 'procedureController', 'groupController', 'currentGroupPanelController', 'persistentStore', 'master']];
  [sut initWithReservationDataController: sut.reservationDataController
                           animalController: sut.animalController
                        procedureController: sut.procedureController
                            groupController: sut.groupController
                currentGroupPanelController: sut.currentGroupPanelController
                            persistentStore: sut.persistentStore
                                     master: sut.master];
}

@end
