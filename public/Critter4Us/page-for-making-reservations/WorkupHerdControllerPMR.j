@import "../controller/PanelController.j"

@implementation WorkupHerdControllerPMR : PanelController
{
  CPButton newWorkupHerdButton;
  CPDropTarget procedureDropTarget;
  CPCollectionView procedureCollectionView;
  CPDropTarget animalDropTarget;
  CPCollectionView animalCollectionView;
}

-(void) awakeFromCib
{
  [animalDropTarget setNormalColor: AnimalHintColor andHoverColor: AnimalStrongHintColor];
  [animalDropTarget acceptDragType: AnimalDragType];
}

@end



