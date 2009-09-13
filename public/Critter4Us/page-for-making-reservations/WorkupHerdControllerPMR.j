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



