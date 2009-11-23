@import "../../cib/NameListControllerSubgraph.j"

@implementation ProcedureControllerSubgraphPMR : NameListControllerSubgraph
{
}

- (CPInteger) xPosition
{
  return FarthestLeftWindowX;
}

- (CPString) nameListTitle
{
  return "Procedures";
}

- (CPColor) color
{
  return ProcedureHintColor;
}



@end
