@import <AppKit/AppKit.j>

@import "../persistence/PersistentStore.j"
@import "../util/StateMachineCoordinator.j"

@import "AnimalsControllerPDA.j"
@import "BackgroundControllerPDA.j"
@import "../cib/PageControllerSubgraph.j"
@import "state-machine/AwaitingDateChoiceStepPDA.j"

@implementation CibPDA : Subgraph
{
  PageControllerSubgraph pageControllerSubgraph;

  BackgroundControllerPDA backgroundController;
  PersistentStore persistentStore;

  AnimalsControllerPDA animalsController;

  View changeableDateView;
  View fixedDateView;
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
                'backgroundController' : [self backgroundController]
  };
  [[StateMachineCoordinator coordinating: peers]
    takeStep: AwaitingDateChoiceStepPDA];
}

- (void) drawControlledSubgraphsIn: (CPWindow) theWindow
{
  pageControllerSubgraph =
    [self custom: [[PageControllerSubgraph alloc]
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

  var submitButton = [[CPButton alloc] initWithFrame: CGRectMake(380 + 300,
                                                                 150, 250, 30)];
  [submitButton setTitle: "Take Chosen Animals Out of Service"];
  [submitButton setHidden: YES];
  [pageControllerSubgraph.pageView addSubview: submitButton];
  
  animalsController = [self custom: [[AnimalsControllerPDA alloc] init]];
  animalsController.availablePanelController = [[PanelController alloc] initWithPanel: availablePanel];
  animalsController.usedPanelController = [[PanelController alloc] initWithPanel: usedPanel];
  animalsController.available = availablePanel.collectionView;
  animalsController.used = usedPanel.collectionView;
  animalsController.submitButton = submitButton;
  
  [availablePanel.collectionView setDelegate: animalsController];
  [usedPanel.collectionView setDelegate: animalsController];

  [submitButton setTarget: animalsController];
  [submitButton setAction: @selector(removeAnimalsFromService:)];
  

  [self initOnPage: pageControllerSubgraph.pageView];
}

- (void) connectRemainingOutlets
{
  [pageControllerSubgraph.controller addPanelControllersFromArray: 
                           [animalsController.availablePanelController, 
                            animalsController.usedPanelController]];
}


-(id) initOnPage: pageView
{

  var dateInstructionLabel = [[CPTextField alloc] initWithFrame:CGRectMake(10, 30, 440, 30)];
  [dateInstructionLabel setStringValue: "On what date should the animals be taken out of service? "];
  [pageView addSubview: dateInstructionLabel];
  
  dateField = [[CPTextField alloc] initWithFrame:CGRectMake(330, 25, 100, 30)];
  [dateField setEditable:YES];
  [dateField setBezeled:YES];
  var date = new Date();
  [dateField setStringValue: [CPString stringWithFormat: "%d-%d-%d", date.getFullYear(), date.getMonth()+1, date.getDate()]];
  [pageView addSubview:dateField];

  var showButton = [[CPButton alloc] initWithFrame:  
CGRectMake(450, 28, 250, 30)];
  [showButton setTitle: "Show Animals In Service on that Date"];
  [showButton setHidden: NO];
  [pageView addSubview:showButton];
  [self backgroundController].showButton = showButton;
  [showButton setTarget: [self backgroundController]];
  [showButton setAction: @selector(animalsInServiceForDate:)];
  [self backgroundController].dateField = dateField;
}  

- (void) backgroundController
{
  if (!backgroundController)
    backgroundController = [self custom: [[BackgroundControllerPDA alloc] init]];
  return backgroundController;
}

@end
