@import "Subgraph.j"
@import "../WorkupHerdControllerPMR.j"
@import "../../view/NameListPanel.j"
@import "../ConstantsPMR.j"
@import "../../view/DropTarget.j"

@implementation WorkupHerdControllerSubgraph : Subgraph
{
  id controller;
  CPButton newWorkupHerdButton;
  CPDropTarget procedureDropTarget;
  CPCollectionView procedureCollectionView;
  CPDropTarget animalDropTarget;
  CPCollectionView animalCollectionView;
  CPanel panel;
}

- (id) initAbovePage: (CPView) aPage
{
  self = [super init];
  panel = [self firstWorkupHerdPanel];

  controller = [self custom: [[WorkupHerdControllerPMR alloc] init]];
  [self placeNewButtonOn: aPage];

  // Procedure half
  procedureDropTarget = [[CPView alloc] initWithFrame: CGRectMake(FirstTargetX, 0, TargetWidth, TargetViewHeight)];
  [[panel contentView] addSubview: procedureDropTarget];
  procedureCollectionView = [[NamedObjectCollectionView alloc]
                              initWithFrame: CGRectMakeZero()];
  [procedureCollectionView fitTidilyWithin: procedureDropTarget];

  [procedureCollectionView setDelegate: controller];
  [procedureDropTarget.controller = controller];
        
  // Animal half
  animalDropTarget = [[DropTarget alloc] initWithFrame: CGRectMake(SecondTargetX, 0, TargetWidth, TargetViewHeight)];
  [[panel contentView] addSubview: animalDropTarget];
  animalCollectionView = [[NamedObjectCollectionView alloc]
                              initWithFrame: CGRectMakeZero()];
  [animalDropTarget surround: animalCollectionView];
  [animalCollectionView setDelegate: controller];
  [animalDropTarget.controller = controller];
  return self;
}

-(CPPanel) firstWorkupHerdPanel
{
  var rect = CGRectMake(FirstGroupingWindowX, WindowTops, GroupingWindowWidth,
                        TargetWindowHeight);
  var panel = [[CPPanel alloc] initWithContentRect: rect
                                          styleMask:CPHUDBackgroundWindowMask | CPResizableWindowMask];
  [panel setLevel:CPFloatingWindowLevel];
  [panel setTitle:@"Drag from left and right to group procedures with animals used for them"];
  [panel orderFront: self]; // TODO: delete when page layout done.
  return panel;
}


- (void) connectOutlets
{
  controller.newWorkupHerdButton = newWorkupHerdButton;
  controller.procedureDropTarget = procedureDropTarget;
  controller.procedureCollectionView = procedureCollectionView;
  controller.animalDropTarget = animalDropTarget;
  controller.animalCollectionView = animalCollectionView;
  controller.panel = panel;
}



- (CPButton) placeNewButtonOn: pageView
{
  newWorkupHerdButton = [[CPButton alloc] initWithFrame:CGRectMake(385, 400, 220, 30)];
  [newWorkupHerdButton setTitle: "New group (doesn't work yet)"];
  [newWorkupHerdButton setHidden: YES]; 
  [pageView addSubview:newWorkupHerdButton];
  // [restartButton setTarget: controller];
  // [restartButton setAction: @selector(abandonReservation:)];
}


@end
