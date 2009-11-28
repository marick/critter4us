@import "../../cib/NameListControllerSubgraph.j"
@import "../AnimalListControllerPDA.j"

@implementation FromListSubgraphPDA : NameListControllerSubgraph
{
}

- (id) newController
{
  return [AnimalListControllerPDA alloc];
}


- (CPInteger) xPosition
{
  return 80;
}

- (CPInteger) yPosition
{
  return 150;
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
