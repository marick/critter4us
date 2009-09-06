@import "Subgraph.j"

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


  controller.pageView = pageView;

  return self;
}

-(void) putPageViewOverWindow: window
{
  var containingView = [window contentView];
  pageView = [[CPView alloc] initWithFrame: [containingView frame]];
  [containingView addSubview: pageView];
}



@end
