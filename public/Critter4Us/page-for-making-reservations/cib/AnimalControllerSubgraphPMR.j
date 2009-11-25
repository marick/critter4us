@import "FromToNameListControllerSubgraphPMR.j"


@implementation AnimalControllerSubgraphPMR : FromToNameListControllerSubgraphPMR
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
