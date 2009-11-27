@import "../../util/Step.j"
@import "AwaitingAnimalListStepPDA.j"

@implementation AwaitingDateChoiceStepPDA : Step
{
}

- (void) setUpNotifications
{
  [self notificationNamed: UserWantsAnimalsInServiceOnDateNews
                      calls: @selector(fetchAnimalList:)];
}

- (void) start
{
}

- (void) fetchAnimalList: aNotification
{
  [self afterResigningInFavorOf: AwaitingAnimalListStepPDA
             causeNextEventWith: function() { 
      [persistentStore fetchAnimalsInServiceOnDate: [aNotification object]];
    }];
}


@end
