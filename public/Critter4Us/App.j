@import <AppKit/AppKit.j>
@import "cib/AllReservationsPageCib.j"
@import "cib/MainMenuCib.j"
@import "page-for-making-reservations/CibPMR.j"

@implementation App : CPObject
{
  CPWindow theWindow;
  CPObject allReservationsPageController;
  CPObject pmrPageController;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
  theWindow = [[CPWindow alloc] initWithContentRect: CGRectMakeZero()
                                          styleMask: CPBorderlessBridgeWindowMask];
  [theWindow orderFront:self];

  [self createMainMenu];
  [self createCibPMR];
  [self createAllReservationsPage];

  [self activateReservationMaker: self];
}

-(void)createAllReservationsPage
{
  [[AllReservationsPageCib alloc] instantiatePageInWindow: theWindow withOwner: self];
}

-(void)createCibPMR
{
  [[CibPMR alloc] instantiatePageInWindow: theWindow withOwner: self];
}

-(void)createMainMenu
{
  [[MainMenuCib alloc] initializeWithOwner: self];
}

- (void) activateReservationViewer: (CPMenuItem) sender
{
  [pmrPageController disappear];
  [allReservationsPageController appear];
}

- (void) activateReservationMaker: (CPMenuItem) sender
{
  [pmrPageController appear];
  [allReservationsPageController disappear];
}

@end

