@implementation WorkupHerdControllerPMR : CPObject
{
  //  CPView redisplayAll;

  AnimalControllerPMR animalController;
  ProcedureControllerPMR procedureController;
  CPButton newButton;
}


-(void) hideOnPageControls
{
  [newGroupButton setHidden: YES];
}

-(void) showOnPageControls
{
  [newGroupButton setHidden: NO];
}

-(void) droppedProcedure: sender
{
  var name = [sender droppedString];
  // alert("new procedure to add to " + [[procedureView content] description]);
  [procedureView setContent: [[procedureView content] arrayByAddingObject: name]];
  //  [redisplayAll setNeedsDisplay: YES];
}

-(void) droppedAnimal: sender
{
  var name = [sender droppedString];
  //  alert("new procedure to add to " + [[procedureView content] description]);
  [animalController selectAnimal: name];
  //  [animalView setContent: [[animalView content] arrayByAddingObject: name]];
  //  [redisplayAll setNeedsDisplay: YES];
}

-(void) spillIt: (CPMutableDictionary) dict
{
  // TODO: This should do work, rather than animalinterfacecontroller and procedureController
}

@end



