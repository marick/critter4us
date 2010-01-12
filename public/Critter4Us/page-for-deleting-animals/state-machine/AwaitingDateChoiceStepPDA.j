@import "../../util/Step.j"
@import "AwaitingAnimalListStepPDA.j"

@implementation AwaitingDateChoiceStepPDA : Step
{
}

- (void) setUpNotifications
{
  [self notificationNamed: UserWantsAnimalsThatCanBeRemovedFromService
                      calls: @selector(fetchAnimalList:)];
}

- (void) start
{
  [backgroundController allowDateEntry];
  [animalsController disappear];
}

- (void) fetchAnimalList: aNotification
{
  [self afterResigningInFavorOf: AwaitingAnimalListStepPDA
             causeNextEventWith: function() { 
      var date = [aNotification object];
      [persistentStore fetchAnimalsInServiceOnDate: date];
      [persistentStore fetchAnimalsWithPendingReservationsOnDate: date];
    }];
}


@end
