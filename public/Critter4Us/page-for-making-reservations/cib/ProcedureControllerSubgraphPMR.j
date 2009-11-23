@import "FromToNameListControllerSubgraphPMR.j"

@implementation ProcedureControllerSubgraphPMR : FromToNameListControllerSubgraphPMR
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
