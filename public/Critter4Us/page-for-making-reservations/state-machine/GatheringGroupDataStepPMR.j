@import "StepPMR.j"
@import "StoringReservationStepPMR.j"

@implementation GatheringGroupDataStepPMR : StepPMR
{
}

- (void) setUpNotifications
{
  [self notificationNamed: AnimalAndProcedureNews
                    calls: @selector(updateControllersWithAnimalAndProcedureInfo:)];
  [self notificationNamed: ReservationRetrievedNews
                    calls: @selector(initializeControllersWithEntirelyNewInfo:)];
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
  [procedureController appear];
  [animalController appear];
  [groupController appear];
  [groupController showGroupButtons];
  [groupController addEmptyGroupToCollection];
  [currentGroupPanelController appear];
}

                       // Getting Data For This State

- (void) updateControllersWithAnimalAndProcedureInfo: aNotification
{
  var dict = [aNotification object];
  var animals = [dict valueForKey: 'animals'];
  var procedures = [dict valueForKey: 'procedures'];
  [reservationDataController noChange];
  [animalController allPossibleObjects: animals];
  [procedureController allPossibleObjects: procedures];
  [groupController redisplayInLightOf: procedures];
}

- (void) initializeControllersWithEntirelyNewInfo: aNotification
{
  var dict = [aNotification object];
  var animals = [dict valueForKey: 'animals'];
  var procedures = [dict valueForKey: 'procedures'];
  var groups = [dict valueForKey: 'groups'];
  [reservationDataController setNewValuesFrom: dict];
  [animalController allPossibleObjects: animals];
  [procedureController allPossibleObjects: procedures];
  [groupController allPossibleObjects: groups];
  [groupController redisplayInLightOf: procedures];
}


- (void) initializeControllersWithEntirelyNewInfo: aNotification
{
  var dict = [aNotification object];
  [self allButRecalculatingGroups: dict];
  [self recalculatingGroups: dict];
}

- (void) allButRecalculatingGroups: dict
{
  var animals = [dict valueForKey: 'animals'];
  var procedures = [dict valueForKey: 'procedures'];
  var groups = [dict valueForKey: 'groups'];
  [reservationDataController setNewValuesFrom: dict];
  [animalController allPossibleObjects: animals];
  [procedureController allPossibleObjects: procedures];
  [groupController allPossibleObjects: groups];
}

- (void) recalculatingGroups: dict
{
  var procedures = [dict valueForKey: 'procedures'];
  var groups = [dict valueForKey: 'groups'];
  [groupController redisplayInLightOf: procedures];
}


                        // Messing Around Within the State

- (void) usedObjectsHaveChanged: aNotification
{
  [reservationDataController noChange];
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

  [reservationDataController noChange];
  [animalController presetUsed: [group animals]];
  [animalController withholdNamedObjects: [aggregate animalsThisProcedureExcludes]];

  [procedureController presetUsed: [group procedures]];
  [groupController noChange]; // it generated the notification
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
