@import "../controller/PanelController.j"

@implementation WorkupHerdControllerPMR : PanelController
{
  CPButton newWorkupHerdButton;
  DropTarget procedureDropTarget;
  CPCollectionView procedureCollectionView;
  DropTarget animalDropTarget;
  CPCollectionView animalCollectionView;
}

-(void) awakeFromCib
{
  [animalDropTarget setNormalColor: AnimalHintColor andHoverColor: AnimalStrongHintColor];
  [animalDropTarget acceptDragType: AnimalDragType];
}

- (CPBoolean) receiveNewItem: animalArray
{
  var originalArray = [animalCollectionView content];
  [animalCollectionView setContent:
                          [originalArray arrayByAddingObjectsFromArray: animalArray]];
  [animalCollectionView setNeedsDisplay: YES];
  return YES;
}

- (CPBoolean) canBeDropped: animal
{
  return YES;
}

@end



