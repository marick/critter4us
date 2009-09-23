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

- (void) setUpNotifications
{
  [self notificationNamed: ReservationDataAvailable
                    calls: @selector(reservationDataAvailable:)];
  [self notificationNamed: InitialDataForACourseSessionNews
                    calls: @selector(reservationDataRetrieved:)];
  [self notificationNamed: DifferentObjectsUsedNews
                    calls: @selector(usedObjectsHaveChanged:)];
  [self notificationNamed: TimeToReserveNews
                    calls: @selector(gatherAndSendNewReservation:)];
  [self notificationNamed: SwitchToGroupNews
                    calls: @selector(switchToNewGroup:)];
}

- (void) reservationDataAvailable: aNotification
{
  [persistentStore loadInfoRelevantToDate: [[aNotification object] valueForKey: 'date']
                                     time: [[aNotification object] valueForKey: 'time']];

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

- (void) gatherAndSendNewReservation: aNotification
{
  var dict = [self gather];
  var reservationID = [persistentStore makeReservation: dict];
  [reservationDataController offerReservationView: reservationID];
  [self beginPostReservationWorkflowStep];
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

- (CPDictionary) beginPostReservationWorkflowStep
{
  [reservationDataController beginningOfReservationWorkflow];
  [procedureController beginningOfReservationWorkflow];
  [animalController beginningOfReservationWorkflow];
  [groupController beginningOfReservationWorkflow];
}
@end
