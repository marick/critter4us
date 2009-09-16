@import "Subgraph.j"
@import "../GroupControllerPMR.j"
@import "../ConstantsPMR.j"
@import "../../view/GroupCollectionView.j"

@implementation GroupControllerSubgraph : Subgraph
{
  id controller;
  CPCollectionView procedureCollectionView;
  CPCollectionView animalCollectionView;
  CPanel panel;
  CPButton newGroupButton;
  CPCollectionView groupCollectionView;
}

- (id) initAbovePage: (CPView) aPage
{
  self = [super init];
  panel = [self firstGroupPanel];

  controller = [self custom: [[GroupControllerPMR alloc] init]];

  // Procedure half
  procedureCollectionView = [[NamedObjectCollectionView alloc]
                              initWithFrame: CGRectMakeZero()];
  [procedureCollectionView placeWithin: [panel contentView]
                              withRect: CGRectMake(FirstTargetX, 0, TargetWidth, TargetViewHeight)
                   withBackgroundColor: ProcedureHintColor];
  [procedureCollectionView setDelegate: controller];
        
  // Animal half
  animalCollectionView = [[NamedObjectCollectionView alloc]
                              initWithFrame: CGRectMakeZero()];
  [animalCollectionView placeWithin: [panel contentView]
                           withRect: CGRectMake(SecondTargetX, 0, TargetWidth, TargetViewHeight)
                withBackgroundColor: AnimalHintColor];
  [animalCollectionView setDelegate: controller];

  [self placeControlsOn: aPage];
  return self;
}

-(CPPanel) firstGroupPanel
{
  var rect = CGRectMake(FirstGroupingWindowX, WindowTops, GroupingWindowWidth,
                        TargetWindowHeight);
  var panel = [[CPPanel alloc] initWithContentRect: rect
                                          styleMask:CPHUDBackgroundWindowMask | CPResizableWindowMask | CPMiniaturizableWindowMask];
  [panel setLevel:CPFloatingWindowLevel];
  [panel setTitle:@"A group of procedures and the animals they will be performed on"];
  [panel orderFront: self]; // TODO: delete when page layout done.
  return panel;
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
  groupCollectionView = [[GroupCollectionView alloc] initWithFrame: rect];
  [pageView addSubview: groupCollectionView];
}

- (void) connectOutlets
{
  controller.newGroupButton = newGroupButton;
  controller.procedureCollectionView = procedureCollectionView;
  controller.animalCollectionView = animalCollectionView;
  controller.panel = panel;
  controller.newGroupButton = newGroupButton;
  controller.groupCollectionView = groupCollectionView;
}

@end
