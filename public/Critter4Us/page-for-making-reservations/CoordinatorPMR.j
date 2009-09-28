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

  [animalController allPossibleObjects: [dict valueForKey: 'animals']];
  [procedureController allPossibleObjects: [dict valueForKey: 'procedures']];
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

@end
