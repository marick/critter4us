@import "../../cib/NameListControllerSubgraph.j"
@import "../FromToNamedObjectListControllerPMR.j"

@implementation FromToNameListControllerSubgraphPMR : NameListControllerSubgraph
{
}

- (id) newController
{
  return [FromToNamedObjectListControllerPMR alloc];
}

@end
