@import "../util/AwakeningObject.j"
@import "PageControllerPMR.j"
@import "WorkupHerdControllerPMR.j"
@import "ReservationDataControllerPMR.j"


@implementation CoordinatorPMR : AwakeningObject
{
  ReservationDataControllerPMR reservationDataController;
  AnimalControllerPMR animalController;
  ProcedureControllerPMR procedureController;
  WorkupHerdControllerPMR workupHerdController;
  PageControllerPMR pageController;
  
  PersistentStore persistentStore;
}


@end
