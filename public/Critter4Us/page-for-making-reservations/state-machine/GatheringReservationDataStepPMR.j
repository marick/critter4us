@import "StepPMR.j"
@import "GatheringGroupDataStepPMR.j"

@implementation GatheringReservationDataStepPMR : StepPMR
{
}

- (void) setUpNotifications
{
  [self notificationNamed: ReservationDataAvailable
                    calls: @selector(reservationDataAvailable:)];
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
                                       time: [[aNotification object] valueForKey: 'time']
                           notificationName: InitialDataForACourseSessionNews];
    }];
}

@end
