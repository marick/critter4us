@import <AppKit/AppKit.j>

@import "../persistence/PersistentStore.j"
@import "../util/StateMachineCoordinator.j"

@import "cib/FromListSubgraphPDA.j"
@import "cib/ToListSubgraphPDA.j"
@import "cib/BackgroundControllerSubgraphPDA.j"
@import "cib/PageControllerSubgraphPDA.j"

@import "state-machine/AwaitingDateChoiceStepPDA.j"

@implementation CibPDA : Subgraph
{
  PageControllerSubgraph pageControllerSubgraph;
  FromListSubgraphPDA fromListSubgraph;
  ToListSubgraphPDA toListSubgraph;
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

  [fromListSubgraph.controller appear];
  [toListSubgraph.controller appear];
  [self awakeFromCib];

  var peers = { 'persistentStore' : persistentStore,
                'fromListController' : fromListSubgraph.controller,
                'toListController' : toListSubgraph.controller,
                'backgroundController' : backgroundControllerSubgraph.controller 
  };
  [[StateMachineCoordinator coordinating: peers]
    takeStep: AwaitingDateChoiceStepPDA];
}

- (void) drawControlledSubgraphsIn: (CPWindow) theWindow
{
  pageControllerSubgraph =
    [self custom: [[PageControllerSubgraphPDA alloc]
                    initWithWindow: theWindow]];
  [pageControllerSubgraph connectOutlets];

  fromListSubgraph =
    [self custom: [[FromListSubgraphPDA alloc] init]];
  [fromListSubgraph connectOutlets];

  toListSubgraph =
    [self custom: [[ToListSubgraphPDA alloc] init]];
  [toListSubgraph connectOutlets];

  backgroundControllerSubgraph =
    [self custom: [[BackgroundControllerSubgraphPDA alloc] initOnPage: pageControllerSubgraph.pageView]];
  [backgroundControllerSubgraph connectOutlets];
}

- (void) connectRemainingOutlets
{
  [pageControllerSubgraph.controller addPanelControllersFromArray: 
                           [fromListSubgraph.controller]];
  [pageControllerSubgraph.controller addPanelControllersFromArray: 
                           [toListSubgraph.controller]];
}

@end
