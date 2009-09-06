@import "Subgraph.j"
@import "../ProcedureControllerPMR.j"

@implementation ProcedureControllerSubgraph : Subgraph
{
  ProcedureControllerPMR controller;
  CPCollectionView collectionView;
}


- (id) initWithDragListPanel: (DragListPMR) aPanel
{
  self = [super init];

  controller = [self custom: [[ProcedureControllerPMR alloc] init]];
  
  collectionView = [aPanel addCollectionViewSupplying: ProcedureDragType 
                                       signalingWith: ProcedureHintColor];
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
  return self;
}



- (void) connectOutlets
{
  controller.collectionView = collectionView;
}



@end
