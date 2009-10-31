@import "StepPMR.j"
@import "GatheringGroupDataStepPMR.j"
@import "DateChangingGroupDataStepPMR.j"

@implementation GatheringReservationDataStepPMR : StepPMR
{
}

- (void) setUpNotifications
{
  [self notificationNamed: ReservationDataAvailable
                    calls: @selector(reservationDataAvailable:)];
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
  // TODO: Do the following in every step?
  [NotificationCenter postNotificationName: AdvisoriesAreIrrelevantNews object: nil];
}

- (void) reservationDataAvailable: aNotification
{
  [self afterResigningInFavorOf: GatheringGroupDataStepPMR
             causeNextEventWith: function() { 
    [persistentStore makeURIsWith: [[URIMaker alloc] init]];
    [persistentStore loadInfoRelevantToDate: [[aNotification object] valueForKey: 'date']
                                       time: [[aNotification object] valueForKey: 'time']];
    }];
}

- (void) fetchReservationToEdit: aNotification
{
  var id = [aNotification object];
  [self afterResigningInFavorOf: GatheringGroupDataStepPMR
             causeNextEventWith: function() { 
      [persistentStore makeURIsWith: [[EditingURIMaker alloc] initEditing: id]];
      [persistentStore fetchReservation: id];
    }];
}

- (void) fetchReservationToCopy: aNotification
{
  var id = [aNotification object];
  [self afterResigningInFavorOf: DateChangingGroupDataStepPMR
             causeNextEventWith: function() { 
      [persistentStore makeURIsWith: [[URIMaker alloc] init]];
      [persistentStore fetchReservation: id];
    }];
}

// Util

@end
