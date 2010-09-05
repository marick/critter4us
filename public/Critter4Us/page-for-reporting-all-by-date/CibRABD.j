@import "BackgroundControllerRABD.j"
@import "../cib/PageControllerSubgraph.j"

@implementation CibRABD : Subgraph
{
  CPWindow theWindow;

  CPView background; 
  PageController pageController;

  TimesliceControl timesliceControl;
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
  [self backgroundController].timesliceControl = [self timesliceControl];
  [self backgroundController].reportButton = [self reportButton];
  [self backgroundController].httpMaker = [[HTTPMaker alloc] init];
  [self backgroundController].primitivizer = [[ModelObjectsToPrimitivesConverter alloc] init];
  [[self reportButton] setTarget: [self backgroundController]];
  [[self reportButton] setAction: @selector(report:)];
}

- (void) drawBackground
{
  [[self background] addSubview: [self timesliceControl]];
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

-(id) timesliceControl
{
  if (!timesliceControl)
  {
    timesliceControl = [[TimesliceControl alloc] initAtX: 10 y: 0];
    var all_day = [ [Time morning], [Time afternoon], [Time evening] ];
    [timesliceControl setTimes: all_day];
  }
  return timesliceControl;
}

-(id) reportButton
{
  if (!reportButton)
  {
    reportButton = [[CPButton alloc] initWithFrame: CGRectMake(20, 100, 250, 30)];
    [reportButton setTitle: "Report (in separate window)"];
    [reportButton setHidden: NO];
  }
  return reportButton;
}


@end
