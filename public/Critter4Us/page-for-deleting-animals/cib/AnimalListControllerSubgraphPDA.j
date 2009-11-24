@import "../../cib/NameListControllerSubgraph.j"

@implementation AnimalListControllerSubgraphPDA : NameListControllerSubgraph
{
}

- (id) newController
{
  return [AnimalListControllerPDA alloc];
}


- (CPInteger) xPosition
{
  return FarthestLeftWindowX;
}

- (CPString) nameListTitle
{
  return "Animals Currently Available for Use";
}

- (CPColor) color
{
  return AnimalHintColor;
}

@end
