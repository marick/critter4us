@import "../../cib/NameListControllerSubgraph.j"

@implementation AnimalControllerSubgraphPMR : NameListControllerSubgraph
{
}
- (CPInteger) xPosition
{
  return FarthestRightWindowX;
}

- (CPString) nameListTitle
{
  return "Animals";
}

- (CPColor) color
{
  return AnimalHintColor;
}

@end
