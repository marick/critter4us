@import "../ProcedureControllerPMR.j"
@import "DragListControllerSubgraph.j"

@implementation ProcedureControllerSubgraph : DragListControllerSubgraph
{
}

- (CPInteger) xPosition
{
  return FarthestLeftWindowX;
}

- (CPString) dragListTitle
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
