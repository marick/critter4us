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
  id finishReservationClosure;
}

- (void) awakeFromCib
{
  [super awakeFromCib];
  [self beginReservationWorkflow];
}

- (void) setUpNotifications
{
  [self notificationNamed: ReservationDataAvailable
                    calls: @selector(reservationDataAvailable:)];
  [self notificationNamed: InitialDataForACourseSessionNews
                    calls: @selector(reservationDataRetrieved:)];
  [self notificationNamed: DifferentObjectsUsedNews
                    calls: @selector(usedObjectsHaveChanged:)];
  [self notificationNamed: TimeToReserveNews
                    calls: @selector(finishReservation:)];
  [self notificationNamed: SwitchToGroupNews
                    calls: @selector(switchToNewGroup:)];
  [self notificationNamed: ModifyReservationNews
                    calls: @selector(edit:)];
  [self notificationNamed: DateTimeForCurrentReservationChangedNews
                    calls: @selector(fetchInfoForNewDateTime:)];
  [self notificationNamed: UpdatedDataForACourseSessionNews
                    calls: @selector(useInfoForNewDateTime:)];
}

- (void) reservationDataAvailable: aNotification
{
  [persistentStore loadInfoRelevantToDate: [[aNotification object] valueForKey: 'date']
                                     time: [[aNotification object] valueForKey: 'time']
                         notificationName: InitialDataForACourseSessionNews];
  [self beginCollectingGroupData];
}

- (void) reservationDataRetrieved: aNotification
{
  [self setAllPossibleObjectsInNamedObjectControllers: [aNotification object]];
}

- (void) usedObjectsHaveChanged: aNotification
{
  [groupController updateCurrentGroup];
  if ([aNotification object] == procedureController)
  {
    var procedures = [[aNotification userInfo] valueForKey: 'used'];
    [self filterAccordingToProcedures: procedures];
  }
}

-(void) switchToNewGroup: aNotification
{
  var group = [aNotification object];
  [animalController presetUsed: [group animals]];
  [procedureController presetUsed: [group procedures]];
  [self filterAccordingToProcedures: [group procedures]];
}

- (void) finishReservation: aNotification
{
  var reservationData = [self gather];
  var reservationID = finishReservationClosure(reservationData);
  [reservationDataController offerReservationView: reservationID];
  [self beginReservationWorkflow];
}

- (void) edit: aNotification
{
  [self beginReservationWorkflow];

  var reservationID = [aNotification object];
  var dict = [persistentStore reservation: reservationID];
  [reservationDataController edit: dict];

  [self beginCollectingGroupData];

  [self setAllPossibleObjectsInNamedObjectControllers: dict];
  [groupController allPossibleObjects: [dict valueForKey: 'groups']];

  finishReservationClosure = function (reservationData) {
    return [persistentStore updateReservation: reservationID with: reservationData];
  }

}

- (void) fetchInfoForNewDateTime: aNotification
{
  [persistentStore loadInfoRelevantToDate: [[aNotification object] valueForKey: 'date']
                                     time: [[aNotification object] valueForKey: 'time']
                         notificationName: UpdatedDataForACourseSessionNews];
}

- (void) useInfoForNewDateTime: aNotification
{
  var dict = [aNotification object];
  [self setAllPossibleObjectsInNamedObjectControllers: dict];
  // fetch groups
  // update all the animals
  // warn about excess
  // push back, setting cursor appropriately
}

// Util

- (void) filterAccordingToProcedures: procedures
{
    var aggregate = [Procedure compositeFrom: procedures];
    [animalController withholdAnimals: [aggregate animalsThisProcedureExcludes]];
}

- (CPDictionary) gather
{
  var dict = [CPMutableDictionary dictionary];
  [reservationDataController spillIt: dict];
  [groupController spillIt: dict];
  return dict;
}

- (void) beginReservationWorkflow
{
  [reservationDataController beginningOfReservationWorkflow];
  [procedureController beginningOfReservationWorkflow];
  [animalController beginningOfReservationWorkflow];
  [groupController beginningOfReservationWorkflow];

  [self finishByCreatingNewReservation];
}

- (void) beginCollectingGroupData
{
  [reservationDataController prepareToFinishReservation];
  [groupController prepareToEditGroups];
  [procedureController appear];
  [animalController appear];
  [groupController appear];
}

- (void) finishByCreatingNewReservation
{
  finishReservationClosure = function (reservationData) {
    return [persistentStore makeReservation: reservationData];
  }
}

- (void) setAllPossibleObjectsInNamedObjectControllers: dict
{
  var animals = [dict valueForKey: 'animals'];
  var procedures = [dict valueForKey: 'procedures'];
  [animalController allPossibleObjects: animals];
  [procedureController allPossibleObjects: procedures];
}


@end
