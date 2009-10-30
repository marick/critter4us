@import "StepPMR.j"
@import "GatheringGroupDataStepPMR.j"

@implementation GatheringReservationDataStepPMR : StepPMR
{
}

- (void) setUpNotifications
{
  [self notificationNamed: ReservationDataAvailable
                    calls: @selector(reservationDataAvailable:)];
  [self notificationNamed: ModifyReservationNews
                    calls: @selector(editReservation:)];
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
    [persistentStore loadInfoRelevantToDate: [[aNotification object] valueForKey: 'date']
                                       time: [[aNotification object] valueForKey: 'time']];
    }];
}

- (void) editReservation: aNotification
{
  [self afterResigningInFavorOf: GatheringGroupDataStepPMR
             causeNextEventWith: function() { 
      [persistentStore editReservation: [aNotification object]];
    }];
}

@end
