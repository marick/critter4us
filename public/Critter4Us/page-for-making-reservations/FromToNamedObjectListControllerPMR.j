@import "../controller/NamedObjectListController.j"

@implementation FromToNamedObjectListControllerPMR : NamedObjectListController
{
  CPCollectionView used;
}

- (void) allPossibleObjects: someObjects
{
  [super allPossibleObjects: someObjects];
  [used setContent: []];
  [used setNeedsDisplay: YES];
}

- (void) withholdNamedObjects: someNamedObjects
{
  [super withholdNamedObjects: someNamedObjects];
  [used setContent: 
       [self array: [used content] without: someNamedObjects]];
  [available setContent: 
            [self array: [available content] without: [used content]]];

  [used setNeedsDisplay: YES];
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

- (void) beginningOfReservationWorkflow
{
  [self disappear];
  [available setContent: []];
  [used setContent: []];
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


// Delegate method from view (that's the way CPCollections communicate)
- (void) objectsRemoved: (CPArray) removed fromList: (NamedObjectCollectionView) list
{
  var sink = (list == used) ? available : used;
  [sink addContent:removed];
  var dict = [CPMutableDictionary dictionary];
  [dict setValue: [used content] forKey: 'used'];
  [NotificationCenter postNotificationName: DifferentObjectsUsedNews
                                    object: self
                                  userInfo: dict];
  [sink setNeedsDisplay: YES];
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

@end
