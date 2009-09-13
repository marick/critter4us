@import "../controller/PanelController.j"
@import "ConstantsPMR.j"

@implementation WorkupHerdControllerPMR : PanelController
{
  CPButton newWorkupHerdButton;
  CPCollectionView procedureCollectionView;
  CPCollectionView animalCollectionView;
}

- (CPBoolean) receiveNewItem: objectArray
{
  var elementClassName = [[objectArray lastObject] className];
  var viewInQuestion =  [elementClassName isEqual: "Animal"] ? animalCollectionView
                                                             : procedureCollectionView;

  var originalArray = [viewInQuestion content];
  var newArray = [originalArray arrayByAddingObjectsFromArray: objectArray];
  [newArray sortUsingSelector: @selector(compareNames:)];
  [viewInQuestion setContent: newArray];
  [viewInQuestion setNeedsDisplay: YES];
  return YES;
}

- (CPBoolean) canBeDropped: animal
{
  return YES;
}

@end



