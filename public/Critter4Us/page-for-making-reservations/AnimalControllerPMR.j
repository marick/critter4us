@import "NamedObjectControllerPMR.j"

@implementation AnimalControllerPMR : NamedObjectControllerPMR.j
{
  CPArray originalAnimals;
}

- (void) beginUsing: someAnimals
{
  originalAnimals = [someAnimals copy];
  [super beginUsing: originalAnimals];
}

- (void) withholdAnimals: someAnimals
{
  [used setContent: 
       [self array: [used content] without: someAnimals]];

  [available setContent: 
       [self array: originalAnimals without: someAnimals]];
  [available setContent: 
       [self array: [available content] without: [used content]]];

  [self bothNeedDisplay];
}

- (CPArray) array: array without: someAnimals
{
  var copy = [array copy]
  [copy removeObjectsInArray: someAnimals];
  return copy;
}

-(void) bothNeedDisplay
{
  [available setNeedsDisplay: YES];
  [used setNeedsDisplay: YES];
}

- (void) spillIt: (CPMutableDictionary) dict
{
  [dict setValue: [self usedNames] forKey: 'animals'];
}



@end
