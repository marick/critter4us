@import "../../util/Step.j"

@implementation AwaitingAnimalListStepPDA : Step
{
}

- (void) setUpNotifications
{
  [self notificationNamed: AnimalInServiceListRetrievedNews
                      calls: @selector(gotAnimalList:)];
}

- (void) start
{
}

- (void) gotAnimalList: aNotification
{
}

@end
