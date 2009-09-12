@import "../controller/PanelController.j"

@implementation AnimalControllerPMR : PanelController
{
  CPCollectionView collectionView;
  CPArray animals;
}


- (void) beginUsing: someAnimals
{
  animals = someAnimals;
  //  [panel useNewClass: AnimalItemView forCollectionView: collectionView];
  [collectionView setContent: someAnimals]
  [collectionView setNeedsDisplay: YES];
}

- (CPData)collectionView:(CPCollectionView)aCollectionView dataForItemsAtIndexes:(CPIndexSet)indexes forType:(CPString)aType
{
  return [animals objectsAtIndexes: indexes];
  // TODO: It may be that objects have to be serialized.
  //  var element = [[aCollectionView content] objectAtIndex:[indices firstIndex]];
  //  return [CPKeyedArchiver archivedDataWithRootObject:element];
}

- (CPArray)collectionView:(CPCollectionView)aCollectionView dragTypesForItemsAtIndexes:(CPIndexSet)indices
{
  return [AnimalDragType];
}

@end
