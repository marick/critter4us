@import "../util/AwakeningObject.j"
@import "PageControllerPMR.j"
@import "GroupControllerPMR.j"
@import "ReservationDataControllerPMR.j"
@import "state-machine/GatheringReservationDataStepPMR.j"


@implementation CoordinatorPMR : AwakeningObject
{
  ReservationDataControllerPMR reservationDataController;
  NamedObjectControllerPMR animalController;
  NamedObjectControllerPMR procedureController;
  GroupControllerPMR groupController;
  CurrentGroupPanelController currentGroupPanelController;
  
  PersistentStore persistentStore;
  id finishReservationClosure;

  id currentStep;
}

- (void) awakeFromCib
{
  [super awakeFromCib];
  [self nextStep: GatheringReservationDataStepPMR];
}

- (void) setUpNotifications
{
  //  [self notificationNamed: UpdatedDataForACourseSessionNews
  //                    calls: @selector(useInfoForNewDateTime:)];
}


- (void) finishReservation: aNotification // TO DELETE
{
  var reservationData = [self gather];
  var reservationID = finishReservationClosure(reservationData);
  [reservationDataController offerReservationView: reservationID];
  [self beginReservationWorkflow];
}


- (void) OLD_edit: aNotification
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

- (void) useInfoForNewDateTime: aNotification // DELETE
{
  var dict = [aNotification object];
  [self setAllPossibleObjectsInNamedObjectControllers: dict];
  [groupController exclusionsHaveChangedForThese: [dict valueForKey: 'procedures']]
}

// Util

- (void) filterAnimalsAccordingToProcedures: procedures // DELETE
{
}

- (CPDictionary) gather   // TO DELETE
{
  var dict = [CPMutableDictionary dictionary];
  [reservationDataController spillIt: dict];
  [groupController spillIt: dict];
  return dict;
}

- (void) beginReservationWorkflow // TO DELETE
{
  [currentStep start];
  [self finishByCreatingNewReservation];
}


- (void) beginCollectingGroupData  // TO DELETE
{
  [reservationDataController prepareToFinishReservation];
  [groupController prepareToEditGroups];
  [procedureController appear];
  [animalController appear];
  [groupController appear];
  [currentGroupPanelController appear];
}

- (void) finishByCreatingNewReservation // TO DELETE
{
  finishReservationClosure = function (reservationData) {
    return [persistentStore makeReservation: reservationData];
  }
}

- (void) setAllPossibleObjectsInNamedObjectControllers: dict // TO DELETE
{
  var animals = [dict valueForKey: 'animals'];
  var procedures = [dict valueForKey: 'procedures'];
  [animalController allPossibleObjects: animals];
  [procedureController allPossibleObjects: procedures];
}

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
