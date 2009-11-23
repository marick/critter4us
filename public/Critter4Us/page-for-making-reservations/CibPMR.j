@import <AppKit/AppKit.j>
@import "../util/Constants.j"
@import "../view/NameListPanel.j"
@import "../view/CurrentGroupPanel.j"
@import "../persistence/PersistentStore.j"

@import "ConstantsPMR.j"
@import "CoordinatorPMR.j"

@import "cib/AnimalControllerSubgraphPMR.j"
@import "cib/ProcedureControllerSubgraphPMR.j"
@import "cib/GroupControllerSubgraphPMR.j"
@import "cib/ReservationDataControllerSubgraphPMR.j"
@import "cib/PageControllerSubgraphPMR.j"

@implementation CibPMR : Subgraph
{
  CPPanel procedurePanel;
  CPPanel animalPanel;
  CPPanel groupPanel;

  PageControllerSubgraphPMR pageControllerSubgraph;
  GroupControllerSubgraphPMR groupControllerSubgraph;
  ReservationDataControllerSubgraphPMR reservationDataControllerSubgraph;
  ProcedureControllerSubgraphPMR procedureControllerSubgraph;
  AnimalControllerSubgraphPMR animalControllerSubgraph;

  CurrentGroupPanel currentGroupPanel;
  PanelController currentGroupPanelController;

  CoordinatorPMR coordinator;
  PersistentStore persistentStore;
}

- (void)instantiatePageInWindow: theWindow withOwner: owner
{
  self = [super init];  // TODO: Hack. This should not be an initializer.



  [self drawControlledSubgraphsIn: theWindow];
  coordinator = [self custom: [[CoordinatorPMR alloc] init]];
  persistentStore = [PersistentStore sharedPersistentStore];

  currentGroupPanel = [[CurrentGroupPanel alloc] init];
  currentGroupPanelController = [[PanelController alloc] initWithPanel: currentGroupPanel];

  [self connectRemainingOutlets];

  owner.pmrPageController = pageControllerSubgraph.controller;

  [self awakeFromCib];
}


- (void) drawControlledSubgraphsIn: (CPWindow) theWindow
{
  pageControllerSubgraph =
    [self custom: [[PageControllerSubgraphPMR alloc]
                    initWithWindow: theWindow]];
  [pageControllerSubgraph connectOutlets];

  reservationDataControllerSubgraph =
    [self custom: [[ReservationDataControllerSubgraphPMR alloc]
      initOnPage: pageControllerSubgraph.pageView]];
  [reservationDataControllerSubgraph connectOutlets];

  procedureControllerSubgraph =
    [self custom: [[ProcedureControllerSubgraphPMR alloc] init]];
  [procedureControllerSubgraph connectOutlets];

  animalControllerSubgraph =
    [self custom: [[AnimalControllerSubgraphPMR alloc] init]];
  [animalControllerSubgraph connectOutlets];

  groupControllerSubgraph =
    [self custom: [[GroupControllerSubgraphPMR alloc]
                    initAbovePage: pageControllerSubgraph.pageView]];
  [groupControllerSubgraph connectOutlets];
}



- (void) connectRemainingOutlets
{
  coordinator.persistentStore = persistentStore;
  coordinator.reservationDataController = reservationDataControllerSubgraph.controller;
  coordinator.animalController = animalControllerSubgraph.controller;
  coordinator.procedureController = procedureControllerSubgraph.controller;
  coordinator.groupController = groupControllerSubgraph.controller;
  coordinator.currentGroupPanelController = currentGroupPanelController;

  coordinator.animalController.used = currentGroupPanel.animalCollectionView;
  [currentGroupPanel.animalCollectionView setDelegate: coordinator.animalController];
  coordinator.procedureController.used = currentGroupPanel.procedureCollectionView;
  [currentGroupPanel.procedureCollectionView setDelegate: coordinator.procedureController];

  [pageControllerSubgraph.controller addPanelControllersFromArray: [animalControllerSubgraph.controller,
                                     procedureControllerSubgraph.controller,
                                     groupControllerSubgraph.controller,
                                     reservationDataControllerSubgraph.panelController]];

}
@end
