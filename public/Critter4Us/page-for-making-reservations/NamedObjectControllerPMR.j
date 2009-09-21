@import "../controller/PanelController.j"

@implementation NamedObjectControllerPMR : PanelController
{
  CPArray originalObjects;
  CPCollectionView available;
  CPCollectionView used;
}

- (void) allPossibleObjects: someObjects
{
  originalObjects = [someObjects copy];
  [available setContent: someObjects];
  [used setContent: []];
  [available setNeedsDisplay: YES];
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
