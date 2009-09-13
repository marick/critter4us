@import "NameListControllerSubgraph.j"
@import "../AnimalControllerPMR.j"

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

- (id) dragType
{
  return AnimalDragType;
}

- (CPColor) color
{
  return AnimalHintColor;
}

- (id) newController
{
  return [[AnimalControllerPMR alloc] init];
}

@end
