@import "../../util/Step.j"

@implementation OnlyStepPAA : Step
{
}

- (void) setUpNotifications
{
  [self notificationNamed: UserWantsToAddAnimals
		    calls: @selector(addAnimals:)];
  [self notificationNamed: UserHasAddedAnimals
		    calls: @selector(handleResponse:)];
}

- (void) start
{
}

- (void) addAnimals: aNotification
{
  var animalDescriptions = [aNotification object];
  [persistentStore addAnimals: animalDescriptions];
}

- (void) handleResponse: aNotification
{
  var conflicts = [[aNotification object] valueForKey: 'duplicates'];
  [backgroundController clearForFurtherAdditions];
  [backgroundController populatePageWithAnimals: conflicts];
}

@end
