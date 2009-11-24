@import <AppKit/AppKit.j>

@import "../persistence/PersistentStore.j"
@import "CoordinatorPDA.j"

@import "cib/AnimalListControllerSubgraphPDA.j"
@import "cib/BackgroundControllerSubgraphPDA.j"

@implementation CibPDA : Subgraph
{
  PageControllerSubgraph pageControllerSubgraph;
  AnimalListControllerSubgraphPDA animalListControllerSubgraph;
  BackgroundControllerSubgraphPDA backgroundControllerSubGraph;

  CoordinatorPDA coordinator;
  PersistentStore persistentStore;
}

- (void)instantiatePageInWindow: theWindow withOwner: owner
{
  self = [super init];  // TODO: Hack. This should not be an initializer.

  [self drawControlledSubgraphsIn: theWindow];
  coordinator = [self custom: [[CoordinatorPDA alloc] init]];
  persistentStore = [PersistentStore sharedPersistentStore];
  [self connectRemainingOutlets];

  owner.pdaPageController = pageControllerSubgraph.controller;

  [animalListControllerSubgraph.controller appear];
  [self awakeFromCib];
}

- (void) drawControlledSubgraphsIn: (CPWindow) theWindow
{
  pageControllerSubgraph =
    [self custom: [[PageControllerSubgraph alloc]
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
  coordinator.persistentstore = persistentStore;
  coordinator.animalListController = animalListControllerSubgraph.controller;
  coordinator.backgroundController = backgroundControllerSubgraph.controller;
  
  [pageControllerSubgraph.controller addPanelControllersFromArray: 
                           [animalListControllerSubgraph.controller]];
}

@end
