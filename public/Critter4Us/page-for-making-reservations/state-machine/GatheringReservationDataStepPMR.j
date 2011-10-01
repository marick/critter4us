@import "../../util/Step.j"
@import "../../util/Timeslice.j"
@import "../../persistence/HTTPMaker.j"
@import "GatheringGroupDataStepPMR.j"
@import "DateChangingGroupDataStepPMR.j"

@implementation GatheringReservationDataStepPMR : Step
{
}

- (void) setUpNotifications
{
  [self notificationNamed: UserHasChosenTimeslice
                    calls: @selector(userHasChosenTimeslice:)];
  [self notificationNamed: ModifyReservationNews
                    calls: @selector(fetchReservationToEdit:)];
  [self notificationNamed: CopyReservationNews
                    calls: @selector(fetchReservationToCopy:)];
}

- (void) start
{
  [reservationDataController beginningOfReservationWorkflow];
  [procedureController beginningOfReservationWorkflow];
  [animalController beginningOfReservationWorkflow];
  [groupController beginningOfReservationWorkflow];
  [currentGroupPanelController disappear];
  [notesPanelController disappear];
  // TODO: Do the following in every step?
  [NotificationCenter postNotificationName: AdvisoriesAreIrrelevantNews object: nil];
}

- (void) userHasChosenTimeslice: aNotification
{
  [self afterResigningInFavorOf: GatheringGroupDataStepPMR
             causeNextEventWith: function() { 
      [persistentStore makeHTTPWith: [[HTTPMaker alloc] init]];
      [persistentStore loadInfoRelevantToTimeslice: [aNotification object]];
    }];
}

- (void) fetchReservationToEdit: aNotification
{
  var id = [aNotification object];
  [self afterResigningInFavorOf: GatheringGroupDataStepPMR
             causeNextEventWith: function() { 
      [persistentStore makeHTTPWith: [[EditingHTTPMaker alloc] initEditing: id]];
      [persistentStore fetchReservation: id];
    }];
}

- (void) fetchReservationToCopy: aNotification
{
  var id = [aNotification object];
  [self afterResigningInFavorOf: DateChangingGroupDataStepPMR
             causeNextEventWith: function() { 
      [persistentStore makeHTTPWith: [[HTTPMaker alloc] init]];
      [persistentStore fetchReservation: id];
    }];
}

// Util

@end
