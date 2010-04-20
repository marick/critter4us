@import "../../util/Step.j"

@implementation OnlyStepPAA : Step
{
}

- (void) setUpNotifications
{
  [self notificationNamed: UserWantsToAddAnimals
		    calls: @selector(addAnimals:)];
}

- (void) start
{
}

- (void) addAnimals: aNotification
{
  var animalDescriptions = [aNotification object];
  [persistentStore addAnimals: animalDescriptions];
}

@end
