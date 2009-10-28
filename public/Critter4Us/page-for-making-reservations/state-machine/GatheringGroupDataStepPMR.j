@import "StepPMR.j"
@import "StoringReservationStepPMR.j"

@implementation GatheringGroupDataStepPMR : StepPMR
{
}

- (void) setUpNotifications
{
  [self notificationNamed: InitialDataForACourseSessionNews
                    calls: @selector(reservationDataRetrieved:)];
  [self notificationNamed: TimeToReserveNews
                    calls: @selector(finishReservation:)];
}

-(void) start
{
  [reservationDataController prepareToFinishReservation];
  [groupController prepareToEditGroups];
  [procedureController appear];
  [animalController appear];
  [groupController appear];
  [currentGroupPanelController appear];
}


- (void) reservationDataRetrieved: aNotification
{
  var dict = [aNotification object];
  var animals = [dict valueForKey: 'animals'];
  var procedures = [dict valueForKey: 'procedures'];
  [animalController allPossibleObjects: animals];
  [procedureController allPossibleObjects: procedures];
}

- (void) finishReservation: aNotification
{
  var dict = [CPMutableDictionary dictionary];
  [dict addEntriesFromDictionary: [reservationDataController data]];
  [dict setValue: [groupController groups] forKey: 'groups'];
  [persistentStore makeReservation: dict];
  [self resignInFavorOf: StoringReservationStepPMR];
}

@end
