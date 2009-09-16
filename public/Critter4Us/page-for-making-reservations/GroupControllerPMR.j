@import "../controller/PanelController.j"
@import "ConstantsPMR.j"

@implementation GroupControllerPMR : PanelController
{
  CPButton newGroupButton;
  CPCollectionView procedureCollectionView;
  CPCollectionView animalCollectionView;
  CPCollectionView groupCollectionView;
}

- (void) prepareToFinishReservation
{
  [newGroupButton setHidden: NO];
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

- (void) restart
{
  [self disappear];
  [newGroupButton setHidden: YES];
  [procedureCollectionView setContent: []];
  [animalCollectionView setContent: []];
}
@end



