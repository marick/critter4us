@import "../../cib/PageControllerSubgraph.j"
@import "../PageControllerPDA.j"

@implementation PageControllerSubgraphPDA : PageControllerSubgraph
{
}

- (id) controller
{
  var controller = [[PageControllerPDA alloc] init];
  return controller;
}

@end
