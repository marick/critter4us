@import <AppKit/AppKit.j>
@import "MakeReservationPageCib.j"
@import "AllReservationsPageCib.j"
@import "MainMenuCib.j"

@implementation App : CPObject
{
  CPWindow theWindow;
  CPObject makeReservationPageController;
  CPObject allReservationsPageController;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
  theWindow = [[CPWindow alloc] initWithContentRect: CGRectMakeZero()
                                          styleMask: CPBorderlessBridgeWindowMask];
  [theWindow orderFront:self];

  [self createMainMenu];
  [self createMakeReservationPage];
  [self createAllReservationsPage];
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

-(void)createMainMenu
{
  [[MainMenuCib alloc] initializeWithOwner: self];
}

- (void) activateReservationMaker: (CPMenuItem) sender
{
  [makeReservationPageController appear];
  [makeReservationPageController windowNeedsFirstResponder: theWindow]; // TODO: hack.
  [allReservationsPageController disappear];
}

- (void) activateReservationViewer: (CPMenuItem) sender
{
  [makeReservationPageController disappear];
  [allReservationsPageController appear];
}

@end
