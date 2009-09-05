@import "../util/AwakeningObject.j"

@implementation AnimalControllerPMR : AwakeningObject
{
  DragListPMR sourceView;
  CPDropTarget targetView;

  CPArray allAnimals;
  CPArray availableAnimals;
  CPArray alreadyUsed;
  id nameToKind;
}


- (void) beginUsingAnimals: (CPArray) anArray withKindMap: (id) aJSHash
{
  [self beginUsingAnimals: anArray
	      withKindMap: aJSHash
                andChoose: []];
}

-(void) withholdAnimals: (CPArray) animalsToRemove
{
  [self allAnimalsAreAvailable];
  for(var i=0; i < [animalsToRemove count]; i++) 
    {
      var goner = [animalsToRemove objectAtIndex: i];
      [availableAnimals removeObject: goner];
      [alreadyUsed removeObject: goner];
    }
  [self pushDisplay];
}

- (void) selectAnimal: (DropTarget) sender
{
  animal = [sender droppedString];
  [alreadyUsed addObject: animal];
  [self push: [self displayize: alreadyUsed] into: targetView];
}


- (void) spillIt: (CPMutableDictionary) dict
{
  [dict setValue: alreadyUsed forKey: 'animals'];
}


// Util

- (void) beginUsingAnimals: (CPArray) animals 
               withKindMap: (id) aJSHash
                 andChoose: (CPArray) used
{
  allAnimals = animals;
  alreadyUsed = used;
  nameToKind = aJSHash
  [self allAnimalsAreAvailable];
  [self pushDisplay];

}

- (void) pushDisplay
{
  [self push: [self displayize: availableAnimals]
        into: sourceView];
  [self push: [self displayize: alreadyUsed]
        into: targetView];
}

- (void) push: anArray into: aDestination
{
  [aDestination setContent: anArray];
  [aDestination setNeedsDisplay: YES];
}

- (CPArray) displayize: animals
{
  var retval = [CPArray array];
  for (var i=0; i < [animals count]; i++)
  {
    var animal = animals[i];
    [retval addObject: animal + ' (' + nameToKind[animal] + ')'];
  }
  [retval sortUsingSelector: @selector(caseInsensitiveCompare:)];
  return retval;
}


// Util

- (void)allAnimalsAreAvailable
{
  availableAnimals = [CPArray arrayWithArray: allAnimals];
  [availableAnimals sortUsingSelector: @selector(caseInsensitiveCompare:)];
}
@end
