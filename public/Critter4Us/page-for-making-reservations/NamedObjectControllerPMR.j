@import "../controller/PanelController.j"

@implementation NamedObjectControllerPMR : PanelController
{
  CPCollectionView available;
  CPCollectionView used;
  CPArray objects;
}

- (void) beginUsing: someObjects
{
  objects = [someObjects sortedArrayUsingSelector: @selector(compareNames:)];
  [available setContent: objects];
  [used setContent: []];
  [available setNeedsDisplay: YES];
  [used setNeedsDisplay: YES];
}

- (CPData)collectionView:(CPCollectionView)aCollectionView dataForItemsAtIndexes:(CPIndexSet)indexes forType:(CPString)aType
{
  return [objects objectsAtIndexes: indexes];
}

- (CPArray)collectionView:(CPCollectionView)aCollectionView dragTypesForItemsAtIndexes:(CPIndexSet)indices
{
  return [self dragType];
}

@end
