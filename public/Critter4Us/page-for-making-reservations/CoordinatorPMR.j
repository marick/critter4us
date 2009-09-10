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
  
  PersistentStore persistentStore;
}

- (void) awakeFromCib
{
  [NotificationCenter
   addObserver: self
      selector: @selector(reservationDataAvailable:)
          name: ReservationDataAvailable
        object: nil];
}

- (void) reservationDataAvailable: aNotification
{
  [persistentStore focusOnDate: [[aNotification object] valueForKey: 'date']
                          time: [[aNotification object] valueForKey: 'time']];

  [reservationDataController allowNoDataChanges];
  [reservationDataController prepareToFinishReservation];
  [procedureController appear];
  [animalController appear];
  [workupHerdController appear];
}

@end
