@import "Subgraph.j"
@import "../../view/NameListPanel.j"
@import "../NamedObjectControllerPMR.j"

@implementation NameListControllerSubgraph : Subgraph
{
  id controller;
  CPCollectionView collectionView;
  NameListPanel nameList;
}


- (id) init
{
  self = [super init];
  nameList = [self panelOutlineAtX: [self xPosition]
                         withTitle: [self nameListTitle]];

  controller = [self custom: [[self newController] initWithPanel: nameList]];
  
  collectionView = [nameList addCollectionWithBackgroundColor: [self color]];

  [collectionView setDelegate: controller]; // collection views, oddly, communicate to delegate. I'm following that convention.
  return self;
}

- (id) newController
{
  return [NamedObjectControllerPMR alloc];
}

- (void) connectOutlets
{
  controller.available = collectionView;
  controller.panel = nameList;
}


-(CPPanel) panelOutlineAtX: x withTitle: aTitle
{
  var panelRect = CGRectMake(x, WindowTops, SourceWindowWidth,
                             SourceWindowHeight);
  panel = [self custom: [[NameListPanel alloc] initWithContentRect: panelRect]];
  [panel setTitle: aTitle];
  [panel orderFront: self]; // TODO: delete when page layout done.
  return panel;
}

@end
