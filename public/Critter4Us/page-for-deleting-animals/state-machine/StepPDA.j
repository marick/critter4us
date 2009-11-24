@import "../../util/CritterObject.j"

@implementation StepPDA : CritterObject
{
  StateMachineCoordinator master;
}

- (void) initWithMaster: aCoordinator
{
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
