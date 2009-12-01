@import "NamedObjectListController.j"

@implementation FromToNamedObjectListController : NamedObjectListController
{
  CPCollectionView used;
}

- (void) allPossibleObjects: someObjects
{
  [super allPossibleObjects: someObjects];
  [used setContent: []];
  [used setNeedsDisplay: YES];
}

- (void) emptyLists
{
  [self allPossibleObjects: []];
}


- (void) presetUsed: usedObjects
{
  var availableObjects = [originalObjects copy];
  [availableObjects removeObjectsInArray: usedObjects];
  [available setContent: availableObjects];
  [used setContent: usedObjects];
}

- (void) stopUsingAll
{
  [self presetUsed: []];
}

- (CPArray) usedObjects
{
  return [used content];
}

- (CPArray) usedNames
{
  var enumerator = [[used content] objectEnumerator];
  var animal;
  var names = [];
  while(object = [enumerator nextObject])
  {
    [names addObject: [object name]];
  }
  return names;
}

- (void) preselect: objects
{
  var availableContents = [available contents];
  var usedContents = [];


  var enumerator = [objects objectEnumerator];
  var object;
  while (object = [enumerator nextObject])
  {
    [availableContents removeObject: object];
    [usedContents addObject: object];
  }
  [available setContent: availableContents];
  [used setContent: usedContents];
  [available setNeedsDisplay: YES];
  [used setNeedsDisplay: YES];
}


// Delegate method from view (that's the way CPCollections communicate)
- (void) objectsRemoved: (CPArray) removed fromList: (NamedObjectCollectionView) list
{
  var sink = (list == used) ? available : used;
  [sink addContent:removed];
  [sink setNeedsDisplay: YES];
}


@end
