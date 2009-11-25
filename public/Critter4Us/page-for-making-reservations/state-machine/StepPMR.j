@import "../../util/CritterObject.j"

@implementation StepPMR : CritterObject
{
  ReservationDataControllerPMR reservationDataController;
  FromToNamedObjectListControllerPMR animalController;
  FromToNamedObjectListControllerPMR procedureController;
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

- (void) resignInFavorOf: (StepPMR) step
{
  [self stopObserving];
  [master nextStep: step];
}

- (void) afterResigningInFavorOf: (StepPMR) step
              causeNextEventWith: func
{
  [self resignInFavorOf: step];
  func();
}


@end
