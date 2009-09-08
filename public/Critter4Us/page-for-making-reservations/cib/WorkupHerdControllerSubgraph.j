@import "Subgraph.j"
@import "../WorkupHerdControllerPMR.j"
@import "../DragListPMR.j"
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

  var itemPrototype = [[CPCollectionViewItem alloc] init];
  [itemPrototype setView:[[DragListItemViewPMR alloc] initWithFrame:CGRectMakeZero()]];

  
  // Procedure half
  procedureDropTarget = [[DropTarget alloc] initWithNormalColor: ProcedureHintColor
                                                     hoverColor: ProcedureStrongHintColor
                                                          frame: CGRectMake(FirstTargetX, 0, TargetWidth, TargetViewHeight)
                                                      accepting: ProcedureDragType];
  [[panel contentView] addSubview: procedureDropTarget];
  procedureCollectionView = [[CPCollectionView alloc]
                              initWithFrame: CGRectMakeZero()];
  [procedureDropTarget surround: procedureCollectionView];
  [procedureCollectionView setItemPrototype:itemPrototype];
  [procedureCollectionView setContent: ["abdominocentesis", "rumen fluid collection (rumenocentesis)"]];

        
  // Animal half
  animalDropTarget = [[DropTarget alloc] initWithNormalColor: AnimalHintColor
                                                     hoverColor: AnimalStrongHintColor
                                                          frame: CGRectMake(SecondTargetX, 0, TargetWidth, TargetViewHeight)
                                                      accepting: AnimalDragType];
  [[panel contentView] addSubview: animalDropTarget];
  animalCollectionView = [[CPCollectionView alloc]
                              initWithFrame: CGRectMakeZero()];
  [animalDropTarget surround: animalCollectionView];
  [animalCollectionView setItemPrototype:itemPrototype];
  [animalCollectionView setContent: ["All Star"]];
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
  //  [newWorkupHerdButton setHidden: YES]; TODO: delete when layup right.
  [pageView addSubview:newWorkupHerdButton];
  // [restartButton setTarget: controller];
  // [restartButton setAction: @selector(abandonReservation:)];
}


@end
