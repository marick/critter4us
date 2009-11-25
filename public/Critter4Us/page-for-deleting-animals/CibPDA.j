@import <AppKit/AppKit.j>

@import "../persistence/PersistentStore.j"
@import "../util/StateMachineCoordinator.j"

@import "cib/AnimalListControllerSubgraphPDA.j"
@import "cib/BackgroundControllerSubgraphPDA.j"
@import "cib/PageControllerSubgraphPDA.j"

@import "state-machine/GatheringAnimalListStepPDA.j"


@implementation CibPDA : Subgraph
{
  PageControllerSubgraph pageControllerSubgraph;
  AnimalListControllerSubgraphPDA animalListControllerSubgraph;
  BackgroundControllerSubgraphPDA backgroundControllerSubGraph;

  StateMachineCoordinator coordinator;
  PersistentStore persistentStore;
}

- (void)instantiatePageInWindow: theWindow withOwner: owner
{
  self = [super init];  // TODO: Hack. This should not be an initializer.

  [self drawControlledSubgraphsIn: theWindow];
  persistentStore = [PersistentStore sharedPersistentStore];
  [self connectRemainingOutlets];

  owner.pdaPageController = pageControllerSubgraph.controller;

  [animalListControllerSubgraph.controller appear];
  [self awakeFromCib];

  var peers = { 'persistentStore' : persistentStore,
                'animalListController' : animalListControllerSubgraph.controller,
                'backgroundController' : backgroundControllerSubgraph.controller 
  };
  [[StateMachineCoordinator coordinating: peers]
    takeStep: GatheringAnimalListStepPDA];
}

- (void) drawControlledSubgraphsIn: (CPWindow) theWindow
{
  pageControllerSubgraph =
    [self custom: [[PageControllerSubgraphPDA alloc]
                    initWithWindow: theWindow]];
  [pageControllerSubgraph connectOutlets];

  animalListControllerSubgraph =
    [self custom: [[AnimalListControllerSubgraphPDA alloc] init]];
  [animalListControllerSubgraph connectOutlets];

  backgroundControllerSubgraph =
    [self custom: [[BackgroundControllerSubgraphPDA alloc] initOnPage: pageControllerSubgraph.pageView]];
  [backgroundControllerSubgraph connectOutlets];
}

- (void) connectRemainingOutlets
{
  [pageControllerSubgraph.controller addPanelControllersFromArray: 
                           [animalListControllerSubgraph.controller]];
}

@end
