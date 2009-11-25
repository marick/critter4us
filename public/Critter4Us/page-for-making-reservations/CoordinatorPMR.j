@import "../util/AwakeningObject.j"
@import "PageControllerPMR.j"
@import "GroupControllerPMR.j"
@import "ReservationDataControllerPMR.j"
@import "state-machine/GatheringReservationDataStepPMR.j"


@implementation CoordinatorPMR : AwakeningObject
{
  ReservationDataControllerPMR reservationDataController;
  FromToNamedObjectListControllerPMR animalController;
  FromToNamedObjectListControllerPMR procedureController;
  GroupControllerPMR groupController;
  CurrentGroupPanelController currentGroupPanelController;
  
  PersistentStore persistentStore;

  id currentStep;
}

- (void) awakeFromCib
{
  [super awakeFromCib];
  [self nextStep: GatheringReservationDataStepPMR];
}

// Util

-(void) nextStep: step
{
  currentStep = [[step alloc]
      initWithReservationDataController: reservationDataController
                       animalController: animalController
                    procedureController: procedureController
                        groupController: groupController
            currentGroupPanelController: currentGroupPanelController
                        persistentStore: persistentStore
                                 master: self];
  [currentStep start];
}

@end
