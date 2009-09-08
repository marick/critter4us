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


- (void) mockupSetup  // TODO: Delete this
{
  [super mockupSetup];
  [collectionView setContent: ["abdominocentesis", 
                                                 "Caslick's operation (horses)",
                                                 'CSF collection (lumbosacral)',
                                                 'MRI (horses)',
                                                 'rumen fluid collection (rumenocentesis)',
                                                 'rumen fluid collection (tube)',
                                                 'transtracheal wash (cattle)',
                                                 'z',
                                                 'zz',
                                                 'zzz',
                                                 'zzzz',
                                                 'zzzzz'
                               ]];
}



@end
