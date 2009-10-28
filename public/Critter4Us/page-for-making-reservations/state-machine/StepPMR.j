@import "../../util/CritterObject.j"

@implementation StepPMR : CritterObject
{
  ReservationDataControllerPMR reservationDataController;
  NamedObjectControllerPMR animalController;
  NamedObjectControllerPMR procedureController;
  GroupControllerPMR groupController;
  CurrentGroupPanelController currentGroupPanelController;
  PersistentStore persistentStore;
  CoordinatorPMR master;
}

- (void) initWithReservationDataController: aReservationDataController
                          animalController: anAnimalController
                       procedureController: aProcedureController
                           groupController: aGroupController
              currentGroupPanelController: aGroupPanelController
                           persistentStore: aPersistentStore
                                    master: aCoordinator
{
  reservationDataController = aReservationDataController;
  animalController = anAnimalController;
  procedureController = aProcedureController;
  groupController = aGroupController;
  currentGroupPanelController = aGroupPanelController;
  persistentStore = aPersistentStore;
  master = aCoordinator;

  [self setUpNotifications];
  return self;
}

- (void) start
{
}

- (void) resignInFavorOf: step
{
  [master nextStep: step];
  [self stopObserving];
}

@end
