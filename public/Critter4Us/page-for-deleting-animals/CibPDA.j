@import <AppKit/AppKit.j>

@import "../persistence/PersistentStore.j"
@import "../util/StateMachineCoordinator.j"

@import "cib/BackgroundControllerSubgraphPDA.j"
@import "cib/PageControllerSubgraphPDA.j"

@import "AnimalsControllerPDA.j"
@import "state-machine/AwaitingDateChoiceStepPDA.j"

@implementation CibPDA : Subgraph
{
  PageControllerSubgraph pageControllerSubgraph;
  BackgroundControllerSubgraphPDA backgroundControllerSubGraph;

  StateMachineCoordinator coordinator;
  PersistentStore persistentStore;

  AnimalsControllerPDA animalsController;
}

- (void)instantiatePageInWindow: theWindow withOwner: owner
{
  self = [super init];  // TODO: Hack. This should not be an initializer.

  [self drawControlledSubgraphsIn: theWindow];
  persistentStore = [PersistentStore sharedPersistentStore];
  [self connectRemainingOutlets];

  owner.pdaPageController = pageControllerSubgraph.controller;

  [self awakeFromCib];

  var peers = { 'persistentStore' : persistentStore,
                'animalsController' : animalsController,
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

  var availablePanel = [[NameListPanel alloc] initAtX: 80
                                                    y: 150
                                            withTitle: "Animals That Can Be Removed"
                                                color: AnimalHintColor];

  var usedPanel = [[NameListPanel alloc] initAtX: 80 + 300
                                               y: 150
                                       withTitle: "Animals That *Will* Be Removed"
                                           color: AnimalHintColor];
  
  animalsController = [self custom: [[AnimalsControllerPDA alloc] init]];
  animalsController.availablePanelController = [[PanelController alloc] initWithPanel: availablePanel];
  animalsController.usedPanelController = [[PanelController alloc] initWithPanel: usedPanel];
  animalsController.available = availablePanel.collectionView;
  animalsController.used = usedPanel.collectionView;
  
  [availablePanel.collectionView setDelegate: animalsController];
  [usedPanel.collectionView setDelegate: animalsController];

  backgroundControllerSubgraph =
    [self custom: [[BackgroundControllerSubgraphPDA alloc] initOnPage: pageControllerSubgraph.pageView]];
  [backgroundControllerSubgraph connectOutlets];
}

- (void) connectRemainingOutlets
{
  [pageControllerSubgraph.controller addPanelControllersFromArray: [animalsController]];
}

@end
