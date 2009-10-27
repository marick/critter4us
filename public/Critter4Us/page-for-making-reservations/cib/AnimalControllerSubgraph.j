@import "NameListControllerSubgraph.j"

@implementation AnimalControllerSubgraph : NameListControllerSubgraph
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
