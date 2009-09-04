@implementation PMRGroupingsController : CPWindowController
{
  CPView redisplayAll;
  CPCollectionView procedureView;
  CPCollectionView animalView;

  CPButton newGroupButton;
}


-(void) hideViews
{
  // TODO
}

-(void) showViews
{
  // TODO
}

-(void) addProcedure: aName
{
  // alert("new procedure to add to " + [[procedureView content] description]);
  [procedureView setContent: [[procedureView content] arrayByAddingObject: aName]];
  [redisplayAll setNeedsDisplay: YES];
}

-(void) addAnimal: aName
{
  //  alert("new procedure to add to " + [[procedureView content] description]);
  [animalView setContent: [[animalView content] arrayByAddingObject: aName]];
  [redisplayAll setNeedsDisplay: YES];
}

@end
