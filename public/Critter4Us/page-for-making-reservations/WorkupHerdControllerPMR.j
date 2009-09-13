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
  [animalDropTarget setNormalColor: AnimalHintColor
                     andHoverColor: AnimalStrongHintColor];
  [animalDropTarget acceptDragType: AnimalDragType];
  [procedureDropTarget setNormalColor: ProcedureHintColor
                        andHoverColor: ProcedureStrongHintColor];
  [procedureDropTarget acceptDragType: ProcedureDragType];
}

- (CPBoolean) receiveNewItem: animalArray
{
  var originalArray = [animalCollectionView content];
  var newArray = [originalArray arrayByAddingObjectsFromArray: animalArray];
  [newArray sortUsingSelector: @selector(compareNames:)];
  [animalCollectionView setContent: newArray];
  [animalCollectionView setNeedsDisplay: YES];
  return YES;
}

- (CPBoolean) canBeDropped: animal
{
  return YES;
}

@end



