@import "Subgraph.j"

@implementation PageControllerSubgraph : Subgraph
{
  PageControllerPMR controller;
}

- (id) init
{
  controller = [self custom: [[PageControllerPMR alloc] init]];
  return self;
}

@end
