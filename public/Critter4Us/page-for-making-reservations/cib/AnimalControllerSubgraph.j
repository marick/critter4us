@import "DragListControllerSubgraph.j"
@import "../AnimalControllerPMR.j"

@implementation AnimalControllerSubgraph : DragListControllerSubgraph
{
}
- (CPInteger) xPosition
{
  return FarthestRightWindowX;
}

- (CPString) dragListTitle
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
