@import "Subgraph.j"
@import "../WorkupHerdControllerPMR.j"
@import "../ConstantsPMR.j"
@implementation WorkupHerdControllerSubgraph : Subgraph
{
  id controller;
  CPCollectionView procedureCollectionView;
  CPCollectionView animalCollectionView;
  CPanel panel;
  CPButton newWorkupHerdButton;
}

- (id) initAbovePage: (CPView) aPage
{
  self = [super init];
  panel = [self firstWorkupHerdPanel];

  controller = [self custom: [[WorkupHerdControllerPMR alloc] init]];

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

-(CPPanel) firstWorkupHerdPanel
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
  newWorkupHerdButton = [[CPButton alloc] initWithFrame:CGRectMake(510, 410, 160, 30)];
  [newWorkupHerdButton setTitle: "Add a New Group"];
  [newWorkupHerdButton setHidden: YES]; 
  [pageView addSubview:newWorkupHerdButton];
  [newWorkupHerdButton setTarget: controller];
  [newWorkupHerdButton setAction: @selector(newWorkupHerd:)];
}



- (void) connectOutlets
{
  controller.newWorkupHerdButton = newWorkupHerdButton;
  controller.procedureCollectionView = procedureCollectionView;
  controller.animalCollectionView = animalCollectionView;
  controller.panel = panel;
  controller.newWorkupHerdButton = newWorkupHerdButton;
}





@end
