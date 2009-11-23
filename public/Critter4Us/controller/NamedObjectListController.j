@import "PanelController.j"

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
