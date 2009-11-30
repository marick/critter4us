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

  View background; 
  PageController pageController;

  CPPanel unchosenAnimalsPanel;
  CPPanel chosenAnimalsPanel;
  CPPanelController unchosenAnimalsPanelController;
  CPPanelController chosenAnimalsPanelController;

  BackgroundControllerPDA backgroundController;
  PersistentStore persistentStore;

  AnimalsControllerPDA animalsController;

  View changeableDateView;
  View fixedDateView;

  CPButton submitButton;
  CPButton showButton;
  CPTextField enteringDateInstructionLabel;
  CPTextField dateEntryField;
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

  [self backgroundController].showButton = [self showButton];
  [self backgroundController].dateField = [self dateEntryField];

  [self animalsController].availablePanelController = [self unchosenAnimalsPanelController];
  [self animalsController].usedPanelController = [self chosenAnimalsPanelController];

  [self animalsController].available = [self unchosenAnimalsPanel].collectionView;
  [self animalsController].used = [self chosenAnimalsPanel].collectionView;

  [self animalsController].submitButton = [self submitButton];


  [[self submitButton] setTarget: [self animalsController]];
  [[self submitButton] setAction: @selector(removeAnimalsFromService:)];
  
  [[self showButton] setTarget: [self backgroundController]];
  [[self showButton] setAction: @selector(animalsInServiceForDate:)];


}

- (void) drawBackground
{
  [[self background] addSubview: [self enteringDateInstructionLabel]];
  [[self background] addSubview: [self dateEntryField]];
  [[self background] addSubview: [self showButton]];
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
    unchosenAnimalsPanel = [[NameListPanel alloc] initAtX: 80
                                                        y: 150
                                                withTitle: "Animals That Can Be Removed"
                                                    color: AnimalHintColor];
  }
  return unchosenAnimalsPanel;
}

- (id) chosenAnimalsPanel
{
  if (!chosenAnimalsPanel)
    chosenAnimalsPanel = [[NameListPanel alloc] initAtX: 80 + 300
                                                      y: 150
                                              withTitle: "Animals That *Will* Be Removed"
                                                  color: AnimalHintColor];
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

- (id) showButton
{
  if (!showButton)
  {
    showButton = [[CPButton alloc] initWithFrame: CGRectMake(450, 28, 250, 30)];
    [showButton setTitle: "Show Animals In Service on that Date"];
    [showButton setHidden: NO];
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
    var date = new Date();
    [dateEntryField setStringValue: [CPString stringWithFormat: "%d-%d-%d", date.getFullYear(), date.getMonth()+1, date.getDate()]];
  }
  return dateEntryField;
}

@end
