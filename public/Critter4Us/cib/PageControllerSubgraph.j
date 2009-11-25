@import "Subgraph.j"

@implementation PageControllerSubgraph : Subgraph
{
  id controller;
  CPView pageView;
}

- (id) initWithWindow: theWindow
{
  return [self initWithWindow: theWindow controller: [self controller]];
}

- (id) initWithWindow: theWindow controller: aController
{
  self = [super init];
  controller = [self custom: aController];
  [self putPageViewOverWindow: theWindow];
  return self;
}

- (void) connectOutlets
{
  controller.pageView = pageView;
}

- (id) controller
{
  return [[PageController alloc] init];
}

-(void) putPageViewOverWindow: window
{
  var containingView = [window contentView];
  pageView = [[CPView alloc] initWithFrame: [containingView frame]];
  [containingView addSubview: pageView];
}

@end
