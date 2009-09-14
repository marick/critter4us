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

  [NotificationCenter
   addObserver: self
      selector: @selector(reservationDataRetrieved:)
          name: InitialDataForACourseSessionNews
        object: nil];
}

- (void) reservationDataAvailable: aNotification
{
  [persistentStore loadInfoRelevantToDate: [[aNotification object] valueForKey: 'date']
                                     time: [[aNotification object] valueForKey: 'time']];

  [reservationDataController allowNoDataChanges];
  [reservationDataController prepareToFinishReservation];
  [procedureController appear];
  [animalController appear];
  [workupHerdController appear];
}

- (void) reservationDataRetrieved: aNotification
{
  var animals = [[aNotification object] valueForKey: 'animals'];
  var procedures = [[aNotification object] valueForKey: 'procedures'];
  [animalController beginUsing: animals];
  [procedureController beginUsing: procedures];
}

@end
