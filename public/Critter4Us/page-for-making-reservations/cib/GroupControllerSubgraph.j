@import "Subgraph.j"
@import "../GroupControllerPMR.j"
@import "../ConstantsPMR.j"
@import "../../view/GroupCollectionView.j"

@implementation GroupControllerSubgraph : Subgraph
{
  id controller;
  CPCollectionView readOnlyProcedureCollectionView;
  CPCollectionView readOnlyAnimalCollectionView;
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
  readOnlyProcedureCollectionView = [[NamedObjectCollectionView alloc]
                              initWithFrame: CGRectMakeZero()];
  [readOnlyProcedureCollectionView placeWithin: [panel contentView]
                              withRect: CGRectMake(FirstTargetX, 0, TargetWidth, TargetViewHeight)
                   withBackgroundColor: ProcedureHintColor];
  [readOnlyProcedureCollectionView setDelegate: controller];
        
  // Animal half
  readOnlyAnimalCollectionView = [[NamedObjectCollectionView alloc]
                              initWithFrame: CGRectMakeZero()];
  [readOnlyAnimalCollectionView placeWithin: [panel contentView]
                           withRect: CGRectMake(SecondTargetX, 0, TargetWidth, TargetViewHeight)
                withBackgroundColor: AnimalHintColor];
  [readOnlyAnimalCollectionView setDelegate: controller];

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
  [groupCollectionView setHidden: YES];
  [groupCollectionView setDefaultName: "* No procedures chosen *"];
  [pageView addSubview: groupCollectionView];
}

- (void) connectOutlets
{
  controller.newGroupButton = newGroupButton;
  controller.readOnlyProcedureCollectionView = readOnlyProcedureCollectionView;
  controller.readOnlyAnimalCollectionView = readOnlyAnimalCollectionView;
  controller.panel = panel;
  controller.newGroupButton = newGroupButton;
  controller.groupCollectionView = groupCollectionView;
}

@end
