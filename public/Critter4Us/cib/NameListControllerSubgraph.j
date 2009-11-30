@import "Subgraph.j"
@import "../view/NameListPanel.j"
@import "../controller/NamedObjectListController.j"

@implementation NameListControllerSubgraph : Subgraph
{
  id controller;
  CPCollectionView collectionView;
  NameListPanel nameList;
}


- (id) init
{
  self = [super init];
  nameList = [self custom: [[NameListPanel alloc] initAtX: [self xPosition]
                                                        y: [self yPosition]
                                                withTitle: [self nameListTitle]
                                                    color: [self color]]];

  controller = [self custom: [[self newController] initWithPanel: nameList]];
  
  collectionView = nameList.collectionView;

  [collectionView setDelegate: controller]; // collection views, oddly, communicate to delegate. I'm following that convention.
  return self;
}

- (id) newController
{
  return [NamedObjectListController alloc];
}

- (void) connectOutlets
{
  controller.available = collectionView;
  controller.panel = nameList;
}

- (id) yPosition
{
  return WindowTops;
}

@end
