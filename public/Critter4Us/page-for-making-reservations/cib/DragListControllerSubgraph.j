@import "Subgraph.j"
@import "../../view/NameListPanel.j"

@implementation DragListControllerSubgraph : Subgraph
{
  id controller;
  CPCollectionView collectionView;
  NameListPanel dragList;
}


- (id) init
{
  self = [super init];
  dragList = [self dragPanelOutlineAtX: [self xPosition]
                             withTitle: [self dragListTitle]];

  controller = [self custom: [self newController]];
  
  collectionView = [dragList addCollectionViewSupplying: [self dragType]
                                          signalingWith: [self color]];

  [collectionView setDelegate: controller];
  return self;
}



- (void) connectOutlets
{
  controller.available = collectionView;
  controller.panel = dragList;
}


-(CPPanel) dragPanelOutlineAtX: x withTitle: aTitle
{
  var panelRect = CGRectMake(x, WindowTops, DragSourceWindowWidth,
                             DragSourceWindowHeight);
  panel = [self custom: [[DragListPMR alloc] initWithContentRect: panelRect]];
  [panel setTitle: aTitle];
  [panel orderFront: self]; // TODO: delete when page layout done.
  return panel;
}

@end
