@import "Subgraph.j"
@import "../../view/NameListPanel.j"

@implementation NameListControllerSubgraph : Subgraph
{
  id controller;
  CPCollectionView collectionView;
  NameListPanel nameList;
}


- (id) init
{
  self = [super init];
  nameList = [self dragPanelOutlineAtX: [self xPosition]
                             withTitle: [self nameListTitle]];

  controller = [self custom: [self newController]];
  
  collectionView = [nameList addCollectionWithBackgroundColor: [self color]];

  [collectionView setDelegate: controller];
  return self;
}



- (void) connectOutlets
{
  controller.available = collectionView;
  controller.panel = nameList;
}


-(CPPanel) dragPanelOutlineAtX: x withTitle: aTitle
{
  var panelRect = CGRectMake(x, WindowTops, DragSourceWindowWidth,
                             DragSourceWindowHeight);
  panel = [self custom: [[NameListPanel alloc] initWithContentRect: panelRect]];
  [panel setTitle: aTitle];
  [panel orderFront: self]; // TODO: delete when page layout done.
  return panel;
}

@end
