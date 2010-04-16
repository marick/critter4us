@import <AppKit/AppKit.j>

@import "../persistence/PersistentStore.j"
@import "../util/StateMachineCoordinator.j"

@import "BackgroundControllerPAA.j"
@import "../cib/PageControllerSubgraph.j"
@import "state-machine/OnlyStepPAA.j"
@import "AnimalDescriptionViewPAA.j"

@implementation CibPAA : Subgraph
{
  CPWindow theWindow;

  CPView background; 
  PageController pageController;

  BackgroundControllerPAA backgroundController;
  PersistentStore persistentStore;

  AnimalsControllerPAA animalsController;
  CPArray rows;

  CPButton submitButton;
}

- (void)instantiatePageInWindow: someWindow withOwner: owner
{
  theWindow = someWindow;
  self = [super init];  // TODO: Hack. This should not be an initializer.

  [self drawBackground];
  [self connectControllers];
  [self setKeyViewLoop];

  owner.paaPageController = [self pageController];

  [self awakeFromCib];

  var peers = { 'persistentStore' : [self persistentStore] };
  [[StateMachineCoordinator coordinating: peers]
    takeStep: OnlyStepPAA];
}

- (void) drawBackground
{
  [self drawDefaultsAtX: 20 y: 30];
  [self drawHeaderAtX: 20 y: 70];
  rows = [self drawRowsAtX: 20 y: 90];
  //  [[self background] addSubview: [self animalAdders]];
  [[self background] addSubview: [self submitButton]];
}

- (void) drawDefaultsAtX: x y: y
{
  var width = 200;
  var height = 30;
  var label = [[CPTextField alloc] initWithFrame: CGRectMake(x+25, y, width, height)];
  [label setStringValue: "Use these values as the default:" ];
  [[self background] addSubview: label];

  x += width + 10;
  width = 100;
  var species = [[CPPopUpButton alloc] initWithFrame: CGRectMake(x, y-3, width, height)];
  [species addItemsWithTitles: [self possibleSpecies]];
  [species selectItemWithTitle: [self favoriteSpecies]];
  [[self background] addSubview: species];

  x += width + 10;
  width = 200;
  var note = [[CPTextField alloc] initWithFrame: CGRectMake(x, y-6, width, height)];
  [note setEditable: YES];
  [note setBezeled: YES];
  [note setStringValue: "cow"];
  [[self background] addSubview: note];


}

- (void) drawHeaderAtX: x y: y
{
  var width = 200;
  var height = 30;
  var label = [[CPTextField alloc] initWithFrame: CGRectMake(x+3, y, width, height)];
  [label setStringValue: "Animal name" ];
  [[self background] addSubview: label];

  x += width + 10;
  width = 100;
  var species = [[CPTextField alloc] initWithFrame: CGRectMake(x+3, y, width, height)];
  [species setStringValue: "Species" ];
  [[self background] addSubview: species];

  x += width + 10;
  width = 200;
  var note = [[CPTextField alloc] initWithFrame: CGRectMake(x+3, y, width, height)];
  [note setStringValue: "Note*" ];
  [[self background] addSubview: note];


  x += width + 40;
  width = 300;
  height = 90;
  var note = [[CPTextField alloc] initWithFrame: CGRectMake(x, y, width, height)];
  [note setLineBreakMode: CPLineBreakByWordWrapping];
  [note setStringValue: "* The Note is text that's included with the animal name in the reservation display. It's text like 'cow' or 'gelding'. You don't need to add parentheses." ];
  [[self background] addSubview: note];
}  

- (CPArray) drawRowsAtX: x y: y
{
  var retval = [];
  for (i = 0; i < 10; i++)
    {
      var row = [[AnimalDescriptionViewPAA alloc] initAtX: x y: y+i*32];
      [row setPossibleSpecies: [self possibleSpecies]
		    selecting: [self favoriteSpecies]]
      [row setNote: [self favoriteNote]];
      [[self background] addSubview: row];
      [retval addObject: row];
    }
  return retval;
}



- (void) connectControllers
{
  //  [self backgroundController].changeableDateView = [self changeableDateView];
  [[self submitButton] setTarget: [self backgroundController]];
  [[self submitButton] setAction: @selector(addAnimals:)];
}


// Lazy getters

- (id) persistentStore
{
  if (!persistentStore)
    persistentStore = [PersistentStore sharedPersistentStore];
  return persistentStore;
}


- (id) backgroundController
{
  if (!backgroundController)
    backgroundController = [self custom: [[BackgroundControllerPAA alloc] init]];
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


-(id) submitButton
{
  if (!submitButton)
  {
    submitButton = [[CPButton alloc] initWithFrame: CGRectMake(580, 190, 120, 30)];
    [submitButton setTitle: "Add Animals"];
    [submitButton setHidden: NO];
  }
  return submitButton;
}

- (void) setKeyViewLoop
{
  for (i = 0; i < [rows count]-1; i++)
    {
      [rows[i] keyViewNameFieldTo: rows[i+1]];
      [rows[i] keyViewNoteFieldTo: rows[i+1]];
    }
}

- (CPArray) possibleSpecies
{
  return ["bovine", "caprine", "equine"];
}

- (CPArray) favoriteSpecies
{
  return "bovine";
}

- (CPArray) favoriteNote
{
  return "cow";
}

@end
