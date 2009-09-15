@import "Subgraph.j"
@import "../WorkupHerdControllerPMR.j"
@import "../../view/NameListPanel.j"
@import "../ConstantsPMR.j"
@implementation WorkupHerdControllerSubgraph : Subgraph
{
  id controller;
  CPCollectionView procedureCollectionView;
  CPCollectionView animalCollectionView;
  CPanel panel;
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
  return self;
}

-(CPPanel) firstWorkupHerdPanel
{
  var rect = CGRectMake(FirstGroupingWindowX, WindowTops, GroupingWindowWidth,
                        TargetWindowHeight);
  var panel = [[CPPanel alloc] initWithContentRect: rect
                                          styleMask:CPHUDBackgroundWindowMask | CPResizableWindowMask];
  [panel setLevel:CPFloatingWindowLevel];
  [panel setTitle:@"A group of procedures and the animals they will be performed on"];
  [panel orderFront: self]; // TODO: delete when page layout done.
  return panel;
}


- (void) connectOutlets
{
  controller.newWorkupHerdButton = newWorkupHerdButton;
  controller.procedureCollectionView = procedureCollectionView;
  controller.animalCollectionView = animalCollectionView;
  controller.panel = panel;
}





@end
