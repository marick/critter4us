@import "../../util/Step.j"

@implementation GatheringAnimalListStepPDA : Step
{
}

- (void) setUpNotifications
{
  [self notificationNamed: UserWantsToDeleteAnimalsNews
                      calls: @selector(fetchDeletionData:)];
}

- (void) start
{
}

- (void) fetchDeletionData: aNotification
{
  [persistentStore fetchAnimalDeletionData];
}


@end
