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
      selector: @selector(usedObjectsHaveChanged:)
          name: DifferentObjectsUsedNews
        object: nil];

  [NotificationCenter
   addObserver: self
      selector: @selector(gatherAndSendNewReservation:)
          name: TimeToReserveNews
        object: nil];

  [NotificationCenter
   addObserver: self
      selector: @selector(switchToNewGroup:)
          name: SwitchToGroupNews
        object: nil];
}

- (void) reservationDataAvailable: aNotification
{
  [persistentStore loadInfoRelevantToDate: [[aNotification object] valueForKey: 'date']
                                     time: [[aNotification object] valueForKey: 'time']];

  [reservationDataController allowNoDataChanges];
  [reservationDataController prepareToFinishReservation];
  [groupController prepareToEditGroups];
  [procedureController appear];
  [animalController appear];
  [groupController appear];
}

- (void) reservationDataRetrieved: aNotification
{
  var animals = [[aNotification object] valueForKey: 'animals'];
  var procedures = [[aNotification object] valueForKey: 'procedures'];
  [animalController allPossibleObjects: animals];
  [procedureController allPossibleObjects: procedures];
}

- (void) usedObjectsHaveChanged: aNotification
{
  [groupController updateCurrentGroup];
  if ([aNotification object] == procedureController)
  {
    var procedures = [[aNotification userInfo] valueForKey: 'used'];
    var aggregate = [Procedure compositeFrom: procedures];
    [animalController withholdAnimals: [aggregate animalsThisProcedureExcludes]];
  }
}

-(void) switchToNewGroup: aNotification
{
  [animalController withholdAnimals: []];
  var group = [aNotification object];
  [animalController presetUsed: [group animals]];
  [procedureController presetUsed: [group procedures]];
}

- (void) gatherAndSendNewReservation: aNotification
{
  var dict = [CPMutableDictionary dictionary];
  [reservationDataController spillIt: dict];
  [groupController spillIt: dict];
  var reservationID = [persistentStore makeReservation: dict];

  [reservationDataController offerReservationView: reservationID];

  [reservationDataController beginningOfReservationWorkflow];
  [procedureController beginningOfReservationWorkflow];
  [animalController beginningOfReservationWorkflow];
  [groupController beginningOfReservationWorkflow];

}

@end
