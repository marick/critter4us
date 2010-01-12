@import <Critter4Us/util/StateMachineCoordinator.j>


@implementation SomeRandomStep : CPObject

- (void) initWithMaster: master
{
  return [super init];
}

- (void) start
{
  // Tweak an instance variable. Note assumption that it's been set.
  [counterArray replaceObjectAtIndex: 0 withObject: counterArray[0]+1];
}

@end

@implementation StateMachineCoordinatorTest : OJTestCase

-(void) test_that_coordinator_launches_step_after_setting_instance_variables
{
  var counterArray = [0];

  var machine = [StateMachineCoordinator coordinating: { 'counterArray' : counterArray }];
  [machine takeStep: SomeRandomStep];
  
  [self assert: [1] equals: counterArray];
}


@end

