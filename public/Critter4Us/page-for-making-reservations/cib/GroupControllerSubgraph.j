@import "Subgraph.j"
@import "../GroupControllerPMR.j"
@import "../ConstantsPMR.j"
@import "../../view/ButtonCollectionView.j"

@implementation GroupControllerSubgraph : Subgraph
{
  id controller;
  CPButton newGroupButton;
  CPCollectionView groupCollectionView;
}

- (id) initAbovePage: (CPView) aPage
{
  self = [super init];

  controller = [self custom: [[GroupControllerPMR alloc] initWithPanel: panel]];

  [self placeControlsOn: aPage];
  return self;
}



- (void) placeControlsOn: pageView
{
  newGroupButton = [[CPButton alloc] initWithFrame:CGRectMake(510, 410, 160, 30)];
  [newGroupButton setTitle: "Add a New Group"];
  [newGroupButton setHidden: YES]; 
  [pageView addSubview:newGroupButton];
  [newGroupButton setTarget: controller];
  [newGroupButton setAction: @selector(newGroup:)];

  var rect = CGRectMake(0, 500, 1000, 100);
  groupCollectionView = [[ButtonCollectionView alloc] initWithFrame: rect];
  [groupCollectionView setHidden: YES];
  [groupCollectionView setDefaultName: "* No procedures chosen *"];
  [groupCollectionView setTarget: controller];
  [groupCollectionView setAction: @selector(differentGroupChosen:)];
  [pageView addSubview: groupCollectionView];
}

- (void) connectOutlets
{
  controller.newGroupButton = newGroupButton;
  controller.groupCollectionView = groupCollectionView;
}

@end
