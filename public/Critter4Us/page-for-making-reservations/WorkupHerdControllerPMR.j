@import "../controller/PanelController.j"
@import "ConstantsPMR.j"

@implementation WorkupHerdControllerPMR : PanelController
{
  CPButton newWorkupHerdButton;
  CPCollectionView procedureCollectionView;
  CPCollectionView animalCollectionView;
}

- (void) prepareToFinishReservation
{
  [newWorkupHerdButton setHidden: NO];
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
  [newWorkupHerdButton setHidden: YES];
  [procedureCollectionView setContent: []];
  [animalCollectionView setContent: []];
}
@end



