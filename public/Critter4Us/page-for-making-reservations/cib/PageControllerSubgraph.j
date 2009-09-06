@import "Subgraph.j"
@import "../PageControllerPMR.j"

@implementation PageControllerSubgraph : Subgraph
{
  PageControllerPMR controller;
  CPView pageView;
  DragListPMR procedureDragList;
  DragListPMR animalDragList;
  CPPanel workupHerdPanel;
}

- (id) initWithWindow: theWindow
{
  self = [super init];
  controller = [self custom: [[PageControllerPMR alloc] init]];
  [self putPageViewOverWindow: theWindow];
  procedureDragList = [self dragPanelOutlineAtX: FarthestLeftWindowX
                                      withTitle: "Procedures"];
  workupHerdPanel = [self firstWorkupHerdPanel];
  animalDragList = [self dragPanelOutlineAtX: FarthestRightWindowX
                                   withTitle: "Animals"];
  return self;
}

- (void) connectOutlets
{
  controller.pageView = pageView;
  controller.procedureDragList = procedureDragList;
  controller.animalDragList = animalDragList;
  controller.workupHerdPanel = workupHerdPanel;
}


-(void) putPageViewOverWindow: window
{
  var containingView = [window contentView];
  pageView = [[CPView alloc] initWithFrame: [containingView frame]];
  [containingView addSubview: pageView];
}

-(CPPanel) dragPanelOutlineAtX: x withTitle: aTitle
{
  var panelRect = CGRectMake(x, WindowTops, DragSourceWindowWidth,
                             DragSourceWindowHeight);
  panel = [self custom: [[DragListPMR alloc] initWithContentRect: panelRect]];
  [panel setTitle: aTitle];
  [panel orderFront: self]; // TODO: delete when page layout done.
  return panel;
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





@end
