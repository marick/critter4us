@import "../../util/Step.j"
@import "AwaitingDateChoiceStepPDA.j"

@implementation AwaitingAnimalListStepPDA : Step
{
}

- (void) setUpNotifications
{
  [self notificationNamed: AnimalInServiceListRetrievedNews
                      calls: @selector(gotAnimalList:)];
  [self notificationNamed: AnimalsToRemoveFromServiceNews
                      calls: @selector(userChoseAnimals:)];
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

- (void) userChoseAnimals: aNotification
{
  [self afterResigningInFavorOf: AwaitingDateChoiceStepPDA
             causeNextEventWith: function() { 
      [persistentStore takeAnimals: [aNotification object]
                    outOfServiceOn: [backgroundController effectiveDate]];
    }];
}

@end
