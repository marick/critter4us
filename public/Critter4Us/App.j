@import <AppKit/AppKit.j>
@import "cib/MakeReservationPageCib.j"
@import "cib/AllReservationsPageCib.j"
@import "cib/MainMenuCib.j"
@import "page-for-making-reservations/PageForMakingReservations.j"

@implementation App : CPObject
{
  CPWindow theWindow;
  CPObject makeReservationPageController;
  CPObject allReservationsPageController;
  CPObject pmrPageController;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
  theWindow = [[CPWindow alloc] initWithContentRect: CGRectMakeZero()
                                          styleMask: CPBorderlessBridgeWindowMask];
  [theWindow orderFront:self];

  [self createMainMenu];
  [self createMakeReservationPage];
  [self createAllReservationsPage];
  [self createPageForMakingReservations];
  
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

-(void)createPageForMakingReservations
{
  [[PageForMakingReservations alloc] instantiatePageInWindow: theWindow withOwner: self];
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
  [pmrPageController disappear];
}

- (void) activateReservationViewer: (CPMenuItem) sender
{
  [makeReservationPageController disappear];
  [pmrPageController disappear];
  [allReservationsPageController appear];
}

- (void) activateNewReservationMaker: (CPMenuItem) sender
{
  [makeReservationPageController disappear];
  [pmrPageController appear];
  [allReservationsPageController disappear];
}

@end
