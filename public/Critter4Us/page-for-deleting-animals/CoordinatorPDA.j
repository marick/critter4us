@import "../util/AwakeningObject.j"
@import "AnimalListControllerPDA.j"
@import "state-machine/GatheringAnimalListStepPDA.j"

@implementation CoordinatorPDA : AwakeningObject
{
  AnimalListControllerPDA animalListController;
  PersistentStore persistentStore;
  
  id currentStep;
}

- (void) awakeFromCib
{
  [super awakeFromCib];
  [self nextStep: GatheringAnimalListStepPDA];
}

// Util

-(void) nextStep: step
{
  currentStep = [[step alloc] 
                  initWithAnimalListController: animalListController
                               persistentStore: persistentStore
                                        master: self];
  [currentStep start];
}

@end
