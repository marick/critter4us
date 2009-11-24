@import "../../util/CritterObject.j"

@implementation StepPDA : CritterObject
{
  PersistentStore persistentStore;
  CoordinatorPDA master;
}

- (void) initWithAnimalListController: anAnimalListController
                      persistentStore: aPersistentStore
                               master: aCoordinator
{
  animalListController = anAnimalListController;
  persistentStore = aPersistentStore;
  master = aCoordinator;

  [self setUpNotifications];
  return self;
}

- (void) start
{
}

- (void) resignInFavorOf: (Class) step
{
  [self stopObserving];
  [master nextStep: step];
}

- (void) afterResigningInFavorOf: (Class) step
              causeNextEventWith: func
{
  [self resignInFavorOf: step];
  func();
}


@end
