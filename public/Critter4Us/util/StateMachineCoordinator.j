@implementation StateMachineCoordinator : CPObject
{
  CPDictionary coordinatedObjects;
  id currentStep;
}

+ (StateMachineCoordinator) coordinating: jsDict
{
  return [[self alloc] initCoordinating: jsDict];
}

-(void) takeStep: stepClass
{
  currentStep = [[stepClass alloc] initWithMaster: self];
  [self setStepInstanceVariables: currentStep]
  [currentStep start];
}

// Util

- (StateMachineCoordinator) initCoordinating: jsDict
{
  self = [super init];
  coordinatedObjects = [CPDictionary dictionaryWithJSObject: jsDict];
  return self;
}

-(void) setStepInstanceVariables: step  
{
  var names = [coordinatedObjects allKeys];
  for (var i=0; i < [names count]; i++)
  {
    var instanceVarName = names[i];
    step[instanceVarName] = [coordinatedObjects valueForKey: instanceVarName];
  }
}


@end
