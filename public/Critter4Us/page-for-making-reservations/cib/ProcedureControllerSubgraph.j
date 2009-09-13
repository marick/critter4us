@import "../ProcedureControllerPMR.j"
@import "NameListControllerSubgraph.j"

@implementation ProcedureControllerSubgraph : NameListControllerSubgraph
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

- (id) dragType
{
  return ProcedureDragType;
}

- (CPColor) color
{
  return ProcedureHintColor;
}

- (id) newController
{
  return [[ProcedureControllerPMR alloc] init];
}



@end
