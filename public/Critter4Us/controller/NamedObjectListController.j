@import "PanelController.j"


// TODO: The mixing up of controlling the lists and controlling the
// panels leads to pain, since lists and panels are no longer 1-1.
@implementation NamedObjectListController : PanelController
{
  CPArray originalObjects;
  CPCollectionView available;
}

- (void) allPossibleObjects: someObjects
{
  originalObjects = [someObjects copy];
  [available setContent: someObjects];
  [available setNeedsDisplay: YES];
}

- (void) withholdNamedObjects: someNamedObjects
{
  [available setContent: 
       [self array: originalObjects without: someNamedObjects]];
  [available setNeedsDisplay: YES];
}

- (CPArray) array: array without: someNamedObjects
{
  var copy = [array copy]
  [copy removeObjectsInArray: someNamedObjects];
  return copy;
}


@end
