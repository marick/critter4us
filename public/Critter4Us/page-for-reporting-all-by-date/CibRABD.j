@import "BackgroundControllerRABD.j"
@import "../cib/PageControllerSubgraph.j"

@implementation CibRABD : Subgraph
{
  CPWindow theWindow;

  CPView background; 
  PageController pageController;

  DualDateControl dateControl;
  CPButton reportButton;
  PanelController panelController;
  BackgroundControllerRABD backgroundController;
}

- (void)instantiatePageInWindow: someWindow withOwner: owner
{
  theWindow = someWindow;
  self = [super init];  // TODO: Hack. This should not be an initializer.

  [self connectControllers];
  [self drawBackground];
  owner.rabdPageController = [self pageController];
  [self awakeFromCib];
}

- (void) connectControllers
{
  [self backgroundController].dateControl = [self dateControl];
  [self backgroundController].reportButton = [self reportButton];
  [self backgroundController].httpMaker = [[HTTPMaker alloc] init];
  [self backgroundController].primitivizer = [[ModelObjectsToPrimitivesConverter alloc] init];
  [[self reportButton] setTarget: [self backgroundController]];
  [[self reportButton] setAction: @selector(report:)];
}

- (void) drawBackground
{
  [[self background] addSubview: [self dateControl]];
  [[self background] addSubview: [self reportButton]];
}

// Lazy getters

- (id) backgroundController
{
  if (!backgroundController)
    backgroundController = [self custom: [[BackgroundControllerRABD alloc] init]];
  return backgroundController;
}

- (id) background
{
  if (!background) [self makePageStuff];
  return background;
}

- (id) pageController
{
  if (!pageController) [self makePageStuff];
  return pageController;
}

- (void) makePageStuff
{
  var pageControllerSubgraph =
    [self custom: [[PageControllerSubgraph alloc] initWithWindow: theWindow]];
  [pageControllerSubgraph connectOutlets];
  background = pageControllerSubgraph.pageView;
  pageController = pageControllerSubgraph.controller;
}

-(id) dateControl
{
  if (!dateControl)
  {
    dateControl = [[DualDateControl alloc] initAtX: 20 y: 30];
  }
  return dateControl;
}

-(id) reportButton
{
  if (!reportButton)
  {
    reportButton = [[CPButton alloc] initWithFrame: CGRectMake(20, 110, 250, 30)];
    [reportButton setTitle: "Report (in separate window)"];
    [reportButton setHidden: NO];
  }
  return reportButton;
}


@end
