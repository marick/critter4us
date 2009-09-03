@import <AppKit/AppKit.j>
@import "cib/MakeReservationPageCib.j"
@import "cib/AllReservationsPageCib.j"
@import "cib/MainMenuCib.j"
@import "make-reservations/NewMakeReservationsCib.j"

@implementation App : CPObject
{
  CPWindow theWindow;
  CPObject makeReservationPageController;
  CPObject allReservationsPageController;
  CPObject newMakeReservationPageController;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
  theWindow = [[CPWindow alloc] initWithContentRect: CGRectMakeZero()
                                          styleMask: CPBorderlessBridgeWindowMask];
  [theWindow orderFront:self];

  [self createMainMenu];
  [self createMakeReservationPage];
  [self createAllReservationsPage];
  [self createNewMakeReservationPage];
  
  [self activateReservationMaker: self];
}

-(void)createAllReservationsPage
{
  [[AllReservationsPageCib alloc] instantiatePageInWindow: theWindow withOwner: self];
}

-(void)createMakeReservationPage
{
  [[MakeReservationPageCib alloc] instantiatePageInWindow: theWindow withOwner: self];  
}

-(void)createNewMakeReservationPage
{
  [[NewMakeReservationsCib alloc] instantiatePageInWindow: theWindow withOwner: self];
}

-(void)createMainMenu
{
  [[MainMenuCib alloc] initializeWithOwner: self];
}

- (void) activateReservationMaker: (CPMenuItem) sender
{
  [makeReservationPageController appear];
  [makeReservationPageController windowNeedsFirstResponder: theWindow]; // TODO: hack.
  [allReservationsPageController disappear];
  [newMakeReservationPageController disappear];
}

- (void) activateReservationViewer: (CPMenuItem) sender
{
  [makeReservationPageController disappear];
  [newMakeReservationPageController disappear];
  [allReservationsPageController appear];
}

- (void) activateNewReservationMaker: (CPMenuItem) sender
{
  [makeReservationPageController disappear];
  [newMakeReservationPageController appear];
  [allReservationsPageController disappear];
}

@end
