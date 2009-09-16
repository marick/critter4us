@import "../controller/PanelController.j"

@implementation NamedObjectControllerPMR : PanelController
{
  CPCollectionView available;
  CPCollectionView used;
}

- (void) beginUsing: someObjects
{
  [available setContent: someObjects];
  [used setContent: []];
  [available setNeedsDisplay: YES];
  [used setNeedsDisplay: YES];
}

- (void) beginningOfReservationWorkflow
{
  [self disappear];
  [available setContent: []];
  [used setContent: []];
}

- (void) stopUsingAll
{
  var all = [[available content] arrayByAddingObjectsFromArray: [used content]];
  [available setContent: all];
  [used setContent: []];
}

- (CPArray) usedNames
{
  var enumerator = [[used content] objectEnumerator];
  var animal;
  var names = [];
  while(animal = [enumerator nextObject])
  {
    [names addObject: [animal name]];
  }
  return names;
}

// Delegate methods
- (void) objectsRemoved: (CPArray) removed fromList: (NamedObjectCollectionView) list
{
  var sink = (list == used) ? available : used;
  [sink addContent:removed];
  [sink setNeedsDisplay: YES];
}

@end
