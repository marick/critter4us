@import "../../cib/Subgraph.j"


@implementation BackgroundControllerSubgraphPDA : Subgraph
{
}


-(id) initOnPage: pageView
{
  var instructionLabel = [[CPTextField alloc] initWithFrame:CGRectMake(10, 30, 400, 30)];
  [instructionLabel setStringValue: "Choose an animal to delete."];
  [pageView addSubview: instructionLabel];
  
  return self;
}

@end
