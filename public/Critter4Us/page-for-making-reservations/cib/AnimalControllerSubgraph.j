@import "Subgraph.j"
@import "../AnimalControllerPMR.j"

@implementation AnimalControllerSubgraph : Subgraph
{
  AnimalControllerPMR controller;
  CPCollectionView collectionView;
}

- (id) initWithDragListPanel: (DragListPMR) aPanel
{
  self = [super init];

  controller = [self custom: [[AnimalControllerPMR alloc] init]];
  
  collectionView = [aPanel addCollectionViewSupplying: AnimalDragType 
                                        signalingWith: AnimalHintColor];

  [collectionView setContent: ["All Star (stallion)", "Brooke (cow)", "Pumpkin (mare)"]];
  return self;
}

- (void) connectOutlets
{
  controller.collectionView = collectionView;
}



@end
