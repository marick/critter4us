@import <AppKit/AppKit.j>
@import "../util/Constants.j"
@import "../util/StateMachineCoordinator.j"
@import "../view/NameListPanel.j"
@import "../view/CurrentGroupPanel.j"
@import "../persistence/PersistentStore.j"
@import "../cib/PageControllerSubgraph.j"

@import "ConstantsPMR.j"
@import "PageControllerPMR.j"

@import "cib/AnimalControllerSubgraphPMR.j"
@import "cib/ProcedureControllerSubgraphPMR.j"
@import "cib/GroupControllerSubgraphPMR.j"
@import "cib/ReservationDataControllerSubgraphPMR.j"
@import "state-machine/GatheringReservationDataStepPMR.j"

@implementation CibPMR : Subgraph
{
  CPPanel procedurePanel;
  CPPanel animalPanel;
  CPPanel groupPanel;

  PageControllerSubgraph pageControllerSubgraph;
  GroupControllerSubgraphPMR groupControllerSubgraph;
  ReservationDataControllerSubgraphPMR reservationDataControllerSubgraph;
  ProcedureControllerSubgraphPMR procedureControllerSubgraph;
  AnimalControllerSubgraphPMR animalControllerSubgraph;

  CurrentGroupPanel currentGroupPanel;
  PanelController currentGroupPanelController;

  PersistentStore persistentStore;
}

- (void)instantiatePageInWindow: theWindow withOwner: owner
{
  self = [super init];  // TODO: Hack. This should not be an initializer.



  [self drawControlledSubgraphsIn: theWindow];
  persistentStore = [PersistentStore sharedPersistentStore];

  currentGroupPanel = [[CurrentGroupPanel alloc] init];
  currentGroupPanelController = [[PanelController alloc] initWithPanel: currentGroupPanel];
  [pageControllerSubgraph.controller addPanelController: currentGroupPanelController];


  [self connectRemainingOutlets];

  owner.pmrPageController = pageControllerSubgraph.controller;

  [self awakeFromCib];


  var peers = { 'persistentStore':persistentStore,
                'reservationDataController': reservationDataControllerSubgraph.controller,
                'animalController' : animalControllerSubgraph.controller,
                'procedureController' : procedureControllerSubgraph.controller,
                'groupController' : groupControllerSubgraph.controller,
                'currentGroupPanelController' : currentGroupPanelController
  };
  
  [[StateMachineCoordinator coordinating: peers]
    takeStep: GatheringReservationDataStepPMR];
}


- (void) drawControlledSubgraphsIn: (CPWindow) theWindow
{
  pageControllerSubgraph =
    [self custom: [[PageControllerSubgraph alloc]
                    initWithWindow: theWindow
                        controller: [[PageControllerPMR alloc] init]]];
  [pageControllerSubgraph connectOutlets];

  reservationDataControllerSubgraph =
    [self custom: 
            [[ReservationDataControllerSubgraphPMR alloc]
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
                    initOnPage: pageControllerSubgraph.pageView]];
  [groupControllerSubgraph connectOutlets];
}



- (void) connectRemainingOutlets
{
  var animalController = animalControllerSubgraph.controller;
  animalController.used = currentGroupPanel.animalCollectionView;
  [currentGroupPanel.animalCollectionView setDelegate: animalController];

  var procedureController = procedureControllerSubgraph.controller;
  procedureController.used = currentGroupPanel.procedureCollectionView;
  [currentGroupPanel.procedureCollectionView setDelegate: procedureController];

  [pageControllerSubgraph.controller addPanelControllersFromArray: [animalControllerSubgraph.controller,
                                     procedureControllerSubgraph.controller,
                                     reservationDataControllerSubgraph.panelController]];

}
@end
