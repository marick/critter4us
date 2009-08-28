@import <Foundation/Foundation.j>
@import "MakeReservationPageCib.j"
@import "AllReservationsPageCib.j"

@implementation App : CPObject
{
  CPWindow theWindow;
  CPObject makeReservationPageController;
  CPObject allReservationsPageController;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
  [self createMainMenu];

  theWindow = [[CPWindow alloc] initWithContentRect: CGRectMakeZero()
                                          styleMask: CPBorderlessBridgeWindowMask];
  [theWindow orderFront:self];

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
  var mainMenu = [[CPMenu alloc] initWithTitle:@"MainMenu"];
  //  [mainMenu setAutoEnablesItems:NO];

  var windowMenuItem = [[CPMenuItem alloc] initWithTitle:@"Window" action:nil keyEquivalent:nil];
  var windowMenu = [[CPMenu alloc] initWithTitle:@"Window"];
  var reservationMakerMenuItem = [[CPMenuItem alloc] initWithTitle:@"Reservation Maker" action:@selector(activateReservationMaker:) keyEquivalent:'R'];
  [reservationMakerMenuItem setTarget: self];
  
  var reservationViewerMenuItem = [[CPMenuItem alloc] initWithTitle:@"All Reservations" action:@selector(activateReservationViewer:) keyEquivalent:'A'];
  [reservationViewerMenuItem setTarget: self];

  [reservationMakerMenuItem setKeyEquivalentModifierMask:CPControlKeyMask];  [reservationViewerMenuItem setKeyEquivalentModifierMask:CPControlKeyMask];        
  [windowMenu addItem:reservationMakerMenuItem];
  [windowMenu addItem:reservationViewerMenuItem];
    
  [windowMenuItem setSubmenu:windowMenu];
  [mainMenu addItem:windowMenuItem];
  [mainMenu addItem:[CPMenuItem separatorItem]];

  [CPApp setMainMenu: mainMenu];
  [CPMenu setMenuBarVisible:YES];
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
  [allReservationsPageControllerf appear];
}

@end
