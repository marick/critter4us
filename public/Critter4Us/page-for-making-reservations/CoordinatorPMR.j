@import "../util/AwakeningObject.j"
@import "PageControllerPMR.j"
@import "GroupControllerPMR.j"
@import "ReservationDataControllerPMR.j"


@implementation CoordinatorPMR : AwakeningObject
{
  ReservationDataControllerPMR reservationDataController;
  AnimalControllerPMR animalController;
  ProcedureControllerPMR procedureController;
  GroupControllerPMR groupController;
  
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

  [NotificationCenter
   addObserver: self
      selector: @selector(proceduresInUse:)
          name: ProceduresChosenNews
        object: nil];

  [NotificationCenter
   addObserver: self
      selector: @selector(gatherAndSendNewReservation:)
          name: TimeToReserveNews
        object: nil];
}

- (void) reservationDataAvailable: aNotification
{
  [persistentStore loadInfoRelevantToDate: [[aNotification object] valueForKey: 'date']
                                     time: [[aNotification object] valueForKey: 'time']];

  [reservationDataController allowNoDataChanges];
  [reservationDataController prepareToFinishReservation];
  [groupController prepareToFinishReservation];
  [procedureController appear];
  [animalController appear];
  [groupController appear];
}

- (void) reservationDataRetrieved: aNotification
{
  var animals = [[aNotification object] valueForKey: 'animals'];
  var procedures = [[aNotification object] valueForKey: 'procedures'];
  [animalController beginUsing: animals];
  [procedureController beginUsing: procedures];
}

- (void) proceduresInUse: aNotification
{
  var procedures = [aNotification object];
  var aggregate = [Procedure compositeFrom: procedures];
  [animalController withholdAnimals: [aggregate animalsThisProcedureExcludes]];
}

- (void) gatherAndSendNewReservation: aNotification
{
  var dict = [CPMutableDictionary dictionary];
  [reservationDataController spillIt: dict];
  [procedureController spillIt: dict];
  [animalController spillIt: dict];
  var reservationID = [persistentStore makeReservation: dict];

  [reservationDataController offerReservationView: reservationID];

  [reservationDataController restart];
  [procedureController restart];
  [animalController restart];
  [groupController restart];

}

@end
