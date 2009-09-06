@import <AppKit/AppKit.j>
@import "../util/Constants.j"
@import "../view/DropTarget.j"
@import "../persistence/PersistentStore.j"

@import "ConstantsPMR.j"
@import "DragListPMR.j"
@import "CoordinatorPMR.j"

@import "cib/AnimalControllerSubgraph.j"
@import "cib/ProcedureControllerSubgraph.j"
@import "cib/WorkupHerdControllerSubgraph.j"
@import "cib/reservationDataControllerSubgraph.j"
@import "cib/PageControllerSubgraph.j"

@implementation CibPMR : Subgraph
{
  PageControllerSubgraph pageControllerSubgraph;
  WorkupHerdControllerSubgraph workupHerdControllerSubgraph;
  ReservationDataControllerSubgraph reservationDataControllerSubgraph;
  ProcedureControllerSubgraph procedureControllerSubgraph;
  AnimalControllerSubgraph animalControllerSubgraph;

  CoordinatorPMR coordinator;
  PersistentStore persistentStore;
}

- (void)instantiatePageInWindow: theWindow withOwner: owner
{
  self = [super init];  // TODO: Hack. This should not be an initializer.

  [self drawControlledSubgraphsIn: theWindow];
  coordinator = [self custom: [[CoordinatorPMR alloc] init]];
  persistentStore = [self loadGlobalPersistentStore];
  [self connectOutlets];

  owner.pmrPageController = pageControllerSubgraph.controller;

  [self awakeFromCib];
}

- (void) drawControlledSubgraphsIn: (CPWindow) theWindow
{
  pageControllerSubgraph =
    [[PageControllerSubgraph alloc]
      initWithWindow: theWindow];
  reservationDataControllerSubgraph =
    [[ReservationDataControllerSubgraph alloc]
      initOnPage: pageControllerSubgraph.pageView];
  procedureControllerSubgraph =
    [[ProcedureControllerSubgraph alloc]
      initWithDragListPanel: pageControllerSubgraph.procedurePanel];
  animalControllerSubgraph =
    [[AnimalControllerSubgraph alloc]
        initWithDragListPanel: pageControllerSubgraph.animalPanel];
  workupHerdControllerSubgraph =
    [[WorkupHerdControllerSubgraph alloc]
        initWithPanel: pageControllerSubgraph.workupHerdPanel
            abovePage: pageControllerSubgraph.pageView];
}

- (PersistentStore) loadGlobalPersistentStore
{
  var persistentStore = [self custom: [[PersistentStore alloc] init]];
  persistentStore.network = [[NetworkConnection alloc] init];
  return persistentStore;
}


- (void) connectOutlets
{
  return;
  pageControllerSubgraph.controller.target = target;
  pageControllerSubgraph.controller.animalDragList = animalControllerSubgraph.dragList;
  pageControllerSubgraph.controller.procedureDragList = procedureDragList;

  procedureController.sourceView = procedureDragList;
  procedureController.targetView = procedureCollectionView;

  // TODO needed?
  workupHerdController.animalController = animalControllerSubgraph.controller;
  workupHerdController.procedureController = procedureController;

  coordinator.persistentStore = persistentStore;
  coordinator.reservationDataController = reservationDataController;
  coordinator.animalController = animalControllerSubgraph.controller;
  coordinator.procedureController = procedureController;
  coordinator.workupHerdController = workupHerdController;
  coordinator.pageController = pageControllerSubgraph.controller;
}
@end

