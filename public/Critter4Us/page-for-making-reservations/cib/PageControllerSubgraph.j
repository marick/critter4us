@import "../../cib/Subgraph.j"
@import "../PageControllerPMR.j"

@implementation PageControllerSubgraph : Subgraph
{
  PageControllerPMR controller;
  CPView pageView;
}

- (id) initWithWindow: theWindow
{
  self = [super init];
  controller = [self custom: [[PageControllerPMR alloc] init]];
  [self putPageViewOverWindow: theWindow];
  return self;
}

- (void) connectOutlets
{
  controller.pageView = pageView;
}


-(void) putPageViewOverWindow: window
{
  var containingView = [window contentView];
  pageView = [[CPView alloc] initWithFrame: [containingView frame]];
  [containingView addSubview: pageView];
}

@end
