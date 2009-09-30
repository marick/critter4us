@import <AppKit/AppKit.j>
@import "../util/Constants.j"
@import "../view/NameListPanel.j"
@import "../persistence/PersistentStore.j"

@import "ConstantsPMR.j"
@import "CoordinatorPMR.j"

@import "cib/AnimalControllerSubgraph.j"
@import "cib/ProcedureControllerSubgraph.j"
@import "cib/GroupControllerSubgraph.j"
@import "cib/ReservationDataControllerSubgraph.j"
@import "cib/PageControllerSubgraph.j"

@implementation CibPMR : Subgraph
{
  CPPanel procedurePanel;
  CPPanel animalPanel;
  CPPanel groupPanel;

  PageControllerSubgraph pageControllerSubgraph;
  GroupControllerSubgraph groupControllerSubgraph;
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
  [self connectRemainingOutlets];

  owner.pmrPageController = pageControllerSubgraph.controller;

  [self awakeFromCib];
}


- (void) drawControlledSubgraphsIn: (CPWindow) theWindow
{
  pageControllerSubgraph =
    [self custom: [[PageControllerSubgraph alloc]
                    initWithWindow: theWindow]];
  [pageControllerSubgraph connectOutlets];

  reservationDataControllerSubgraph =
    [self custom: [[ReservationDataControllerSubgraph alloc]
      initOnPage: pageControllerSubgraph.pageView]];
  [reservationDataControllerSubgraph connectOutlets];

  procedureControllerSubgraph =
    [self custom: [[ProcedureControllerSubgraph alloc] init]];
  [procedureControllerSubgraph connectOutlets];

  animalControllerSubgraph =
    [self custom: [[AnimalControllerSubgraph alloc] init]];
  [animalControllerSubgraph connectOutlets];

  groupControllerSubgraph =
    [self custom: [[GroupControllerSubgraph alloc]
                    initAbovePage: pageControllerSubgraph.pageView]];
  [groupControllerSubgraph connectOutlets];
}

- (PersistentStore) loadGlobalPersistentStore
{
  var persistentStore = [self custom: [[PersistentStore alloc] init]];
  persistentStore.network = [[NetworkConnection alloc] init];
  return persistentStore;
}


- (void) connectRemainingOutlets
{
  coordinator.persistentStore = persistentStore;
  coordinator.reservationDataController = reservationDataControllerSubgraph.controller;
  coordinator.animalController = animalControllerSubgraph.controller;
  coordinator.procedureController = procedureControllerSubgraph.controller;
  coordinator.groupController = groupControllerSubgraph.controller;

  coordinator.animalController.used = groupControllerSubgraph.controller.readOnlyAnimalCollectionView;
  coordinator.procedureController.used = groupControllerSubgraph.controller.readOnlyProcedureCollectionView;
  [coordinator.groupController.readOnlyAnimalCollectionView setDelegate: coordinator.animalController];
  [coordinator.groupController.readOnlyProcedureCollectionView setDelegate: coordinator.procedureController];
  

  [pageControllerSubgraph.controller addPanelControllersFromArray: [animalControllerSubgraph.controller,
                                     procedureControllerSubgraph.controller,
                                     groupControllerSubgraph.controller,
                                     reservationDataControllerSubgraph.panelController]];

}
@end
