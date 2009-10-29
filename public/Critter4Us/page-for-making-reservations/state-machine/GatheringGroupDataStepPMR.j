@import "StepPMR.j"
@import "StoringReservationStepPMR.j"

@implementation GatheringGroupDataStepPMR : StepPMR
{
}

- (void) setUpNotifications
{
  [self notificationNamed: AnimalAndProcedureNews
                    calls: @selector(reservationDataRetrieved:)];
  [self notificationNamed: TimeToReserveNews
                    calls: @selector(finishReservation:)];
  [self notificationNamed: DifferentObjectsUsedNews
                    calls: @selector(usedObjectsHaveChanged:)];
  [self notificationNamed: SwitchToGroupNews
                    calls: @selector(switchToNewGroup:)];
  [self notificationNamed: DateTimeForCurrentReservationChangedNews
                    calls: @selector(fetchInfoForNewDateTime:)];
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

                       // Messing around within this state

- (void) reservationDataRetrieved: aNotification
{
  var dict = [aNotification object];
  var animals = [dict valueForKey: 'animals'];
  var procedures = [dict valueForKey: 'procedures'];
  [animalController allPossibleObjects: animals];
  [procedureController allPossibleObjects: procedures];
  [groupController redisplayInLightOf: procedures];
}

- (void) usedObjectsHaveChanged: aNotification
{
  if ([aNotification object] == procedureController)
  {
    var procedures = [[aNotification userInfo] valueForKey: 'used'];
    var aggregate = [Procedure compositeFrom: procedures];
    [animalController withholdNamedObjects: [aggregate animalsThisProcedureExcludes]];
    [procedureController withholdNamedObjects: [aggregate animalsThisProcedureExcludes]];
  }
  [groupController setCurrentGroupProcedures: [procedureController usedObjects]
                                     animals: [animalController usedObjects]];
}

-(void) switchToNewGroup: aNotification
{
  var group = [aNotification object];
  var aggregate = [Procedure compositeFrom: [group procedures]];

  [animalController presetUsed: [group animals]];
  [animalController withholdNamedObjects: [aggregate animalsThisProcedureExcludes]];

  [procedureController presetUsed: [group procedures]];
}


                        // Moving out of this state

- (void) finishReservation: aNotification
{
  var dict = [CPMutableDictionary dictionary];
  [dict addEntriesFromDictionary: [reservationDataController data]];
  [dict setValue: [groupController groups] forKey: 'groups'];

  [self afterResigningInFavorOf: StoringReservationStepPMR
             causeNextEventWith: function() { 
      [persistentStore makeReservation: dict];
    }];
}

-(void) fetchInfoForNewDateTime: aNotification
{
  [persistentStore loadInfoRelevantToDate: [[aNotification object] valueForKey: 'date']
                                     time: [[aNotification object] valueForKey: 'time']]
}

@end
