@import "Subgraph.j"

@implementation AnimalControllerSubgraph : Subgraph
{
  AnimalControllerPMR controller;
}

- (id) init
{
  self = [super init];
  controller = [self custom: [[AnimalControllerPMR alloc] init]];
  return self;
}



@end
