@import "../../cib/Subgraph.j"
@import "../PageControllerPDA.j"

@implementation PageControllerSubgraphPDA : Subgraph
{
  PageControllerPDA controller;
  CPView pageView;
}

- (id) initWithWindow: theWindow
{
  self = [super init];
  controller = [self custom: [[PageControllerPDA alloc] init]];
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
