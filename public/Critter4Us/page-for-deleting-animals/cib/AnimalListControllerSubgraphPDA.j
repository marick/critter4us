@import "../../cib/NameListControllerSubgraph.j"
@import "../AnimalListControllerPDA.j"

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

- (CPInteger) yPosition
{
  return 120;
}

- (CPString) nameListTitle
{
  return "Animals That Can Be Removed";
}

- (CPColor) color
{
  return AnimalHintColor;
}

@end
