@import "../../cib/NameListControllerSubgraph.j"
@import "../AnimalListControllerPDA.j"

@implementation ToListSubgraphPDA : NameListControllerSubgraph
{
}

- (id) newController
{
  return [AnimalListControllerPDA alloc];
}


- (CPInteger) xPosition
{
  return 80 + 300 ;
}

- (CPInteger) yPosition
{
  return 150;
}

- (CPString) nameListTitle
{
  return "Animals That *Will* Be Removed";
}

- (CPColor) color
{
  return AnimalHintColor;
}

@end
