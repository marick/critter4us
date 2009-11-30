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
  [animalsController appear];
  can_be_taken_out = [[aNotification object] valueForKey: 'unused animals'];
  [animalsController allPossibleObjects: can_be_taken_out];
}

@end
