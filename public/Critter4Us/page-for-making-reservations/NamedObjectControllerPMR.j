@import "../controller/PanelController.j"

@implementation NamedObjectControllerPMR : PanelController
{
  CPCollectionView collectionView;
  CPArray objects;
}

- (void) beginUsing: someObjects
{
  objects = [someObjects sortedArrayUsingSelector: @selector(compareNames:)];
  [collectionView setContent: objects]
  [collectionView setNeedsDisplay: YES];
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
