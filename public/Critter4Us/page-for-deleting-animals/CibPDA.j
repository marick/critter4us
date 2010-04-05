@import <AppKit/AppKit.j>

@import "../persistence/PersistentStore.j"
@import "../util/StateMachineCoordinator.j"

@import "AnimalsControllerPDA.j"
@import "BackgroundControllerPDA.j"
@import "../cib/PageControllerSubgraph.j"
@import "state-machine/AwaitingDateChoiceStepPDA.j"

@implementation CibPDA : Subgraph
{
  CPWindow theWindow;

  CPView background; 
  PageController pageController;

  CPPanel unchosenAnimalsPanel;
  CPPanel chosenAnimalsPanel;
  CPPanelController unchosenAnimalsPanelController;
  CPPanelController chosenAnimalsPanelController;

  BackgroundControllerPDA backgroundController;
  PersistentStore persistentStore;

  AnimalsControllerPDA animalsController;

  CPView changeableDateView;
  CPView fixedDateView;
  CPWebView pendingReservationView;
  CPTextField pendingReservationViewInstructions;

  CPButton submitButton;
  CPButton restartButton;
  CPButton showButton;
  CPTextField enteringDateInstructionLabel;
  CPTextField dateEntryField;
  CPTextField noteSelectedDateField;
}

- (void)instantiatePageInWindow: someWindow withOwner: owner
{
  theWindow = someWindow;
  self = [super init];  // TODO: Hack. This should not be an initializer.

  [self connectControllers];
  [self drawBackground];

  owner.pdaPageController = [self pageController];

  [self awakeFromCib];

  var peers = { 'persistentStore' : [self persistentStore],
                'animalsController' : [self animalsController],
                'backgroundController' : [self backgroundController]
  };
  [[StateMachineCoordinator coordinating: peers]
    takeStep: AwaitingDateChoiceStepPDA];
}


- (void) connectControllers
{
  [[self pageController] addPanelControllersFromArray: 
                           [ [self unchosenAnimalsPanelController],
                             [self chosenAnimalsPanelController]]];

  [[self unchosenAnimalsPanel].collectionView setDelegate: [self animalsController]];
  [[self chosenAnimalsPanel].collectionView setDelegate: [self animalsController]];

  [self backgroundController].changeableDateView = [self changeableDateView];
  [self backgroundController].fixedDateView = [self fixedDateView];
  [self backgroundController].dateField = [self dateEntryField];
  [self backgroundController].noteSelectedDateField = [self noteSelectedDateField];
  [self backgroundController].pendingReservationView = [self pendingReservationView];

  [self animalsController].availablePanelController = [self unchosenAnimalsPanelController];
  [self animalsController].usedPanelController = [self chosenAnimalsPanelController];

  [self animalsController].available = [self unchosenAnimalsPanel].collectionView;
  [self animalsController].used = [self chosenAnimalsPanel].collectionView;

  [self animalsController].submitButton = [self submitButton];
  [[self submitButton] setTarget: [self animalsController]];
  [[self submitButton] setAction: @selector(removeAnimalsFromService:)];
  
  [[self showButton] setTarget: [self backgroundController]];
  [[self showButton] setAction: @selector(animalsInServiceForDate:)];

  [[self restartButton] setTarget: [self backgroundController]];
  [[self restartButton] setAction: @selector(restart:)];
}

- (void) drawBackground
{
  [[self background] addSubview: [self changeableDateView]];
  [[self background] addSubview: [self fixedDateView]];
  [[self background] addSubview: [self submitButton]];
}


// Lazy getters

- (id) persistentStore
{
  if (!persistentStore)
    persistentStore = [PersistentStore sharedPersistentStore];
  return persistentStore;
}


- (id) animalsController
{
  if (!animalsController)
    animalsController = [self custom: [[AnimalsControllerPDA alloc] init]];
  return animalsController;
}

- (id) backgroundController
{
  if (!backgroundController)
    backgroundController = [self custom: [[BackgroundControllerPDA alloc] init]];
  return backgroundController;
}

- (id) background
{
  if (!background) [self makePageStuff];
  return background;
}

- (id) pageController
{
  if (!pageController) [self makePageStuff];
  return pageController;
}

- (void) makePageStuff
{
  var pageControllerSubgraph =
    [self custom: [[PageControllerSubgraph alloc] initWithWindow: theWindow]];
  [pageControllerSubgraph connectOutlets];
  background = pageControllerSubgraph.pageView;
  pageController = pageControllerSubgraph.controller;
}

- (id) unchosenAnimalsPanel
{
  if (!unchosenAnimalsPanel)
  {
    rect = CGRectMake(80, 130, SourceWindowWidth, 10 * TextLineHeight);
    unchosenAnimalsPanel = [[NameListPanel alloc]
                             initWithRect: rect
                                    title: "Animals That Can Be Removed"
                                    color: AnimalHintColor];
  }
  return unchosenAnimalsPanel;
}

- (id) chosenAnimalsPanel
{
  if (!chosenAnimalsPanel)
  {
    rect = CGRectMake(80+300, 130, SourceWindowWidth, 10 * TextLineHeight);
    chosenAnimalsPanel = [[NameListPanel alloc] 
                           initWithRect: rect
                                  title: "Animals That *Will* Be Removed"
                                  color: AnimalHintColor];
  }
  return chosenAnimalsPanel;
}

- (id) unchosenAnimalsPanelController
{
  if (!unchosenAnimalsPanelController)
    unchosenAnimalsPanelController = [[PanelController alloc] initWithPanel: [self unchosenAnimalsPanel]];
    return unchosenAnimalsPanelController;
}

- (id) chosenAnimalsPanelController
{
  if (!chosenAnimalsPanelController)
    chosenAnimalsPanelController = [[PanelController alloc] initWithPanel: [self chosenAnimalsPanel]];
    return chosenAnimalsPanelController;
}

-(id) submitButton
{
  if (!submitButton)
  {
    submitButton = [[CPButton alloc] initWithFrame: CGRectMake(380 + 300,
                                                               150, 250, 30)];
    [submitButton setTitle: "Take Chosen Animals Out of Service"];
    [submitButton setHidden: YES];
  }
  return submitButton;
}

-(id) restartButton
{
  if (!restartButton)
  {
    restartButton = [[CPButton alloc] initWithFrame: CGRectMake(350, 28, 250, 30)];
    [restartButton setTitle: "Start Over (Pick a Different Date)"];
  }
  return restartButton;
}

- (id) showButton
{
  if (!showButton)
  {
    showButton = [[CPButton alloc] initWithFrame: CGRectMake(315, 70, 250, 30)];
    [showButton setTitle: "Show Animals In Service on that Date"];
  }
  return showButton;
}


- (id) enteringDateInstructionLabel
{
  if (!enteringDateInstructionLabel)
  {
    enteringDateInstructionLabel = [[CPTextField alloc] initWithFrame:CGRectMake(10, 30, 440, 30)];
    [enteringDateInstructionLabel setStringValue: "On what date should the animals be taken out of service? "];
   }
  return enteringDateInstructionLabel;
}
  

- (id) dateEntryField
{
  if (! dateEntryField)
  {
    dateEntryField = [[CPTextField alloc] initWithFrame:CGRectMake(330, 25, 100, 30)];
    [dateEntryField setEditable:YES];
    [dateEntryField setBezeled:YES];
    [dateEntryField setStringValue: [Timeslice today]];
  }
  return dateEntryField;
}

- (id) changeableDateView
{
  if (!changeableDateView)
  {
    changeableDateView = [[CPView alloc] initWithFrame: [background bounds]];
    [changeableDateView addSubview: [self enteringDateInstructionLabel]];
    [changeableDateView addSubview: [self dateEntryField]];
    [changeableDateView addSubview: [self showButton]];
  }
  return changeableDateView;
}

- (id) fixedDateView
{
  if (!fixedDateView)
  {
    fixedDateView = [[CPView alloc] initWithFrame: [background bounds]];
    [fixedDateView addSubview: [self noteSelectedDateField]];
    [fixedDateView addSubview: [self restartButton]];
    [fixedDateView addSubview: [self pendingReservationViewInstructions]];
    [fixedDateView addSubview: [self pendingReservationView]];
  }
  return fixedDateView;
}

- (id) noteSelectedDateField
{
  if (!noteSelectedDateField)
  {
    noteSelectedDateField = [[CPTextField alloc] initWithFrame:CGRectMake(10, 30, 5200, 30)];
  }
  return noteSelectedDateField;
}

- (id) pendingReservationView
{
  if (!pendingReservationView)
  {
    pendingReservationView = [[CPWebView alloc] initWithFrame: CGRectMake(50,360, 600,200)];
    [pendingReservationView setBackgroundColor: [CPColor redColor]];
  }
  return pendingReservationView;
}

- (id) pendingReservationViewInstructions
{
  if (! pendingReservationViewInstructions)
  {
    pendingReservationViewInstructions = [[CPTextField alloc] initWithFrame: CGRectMake(20,330, 600, 30)];
    [pendingReservationViewInstructions setLineBreakMode: CPLineBreakByWordWrapping];
    [pendingReservationViewInstructions setStringValue: "Any animals that cannot be taken out of service are shown below, along with the reservations that prevent it."];
  }
  return pendingReservationViewInstructions;
}

@end
