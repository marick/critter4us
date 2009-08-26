@import <Foundation/Foundation.j>
@import "FakeMainWindowCib.j"
@import "FakeAllReservationWindowCib.j"

@implementation App : CPObject
{
  CPWindow theWindow;
  CPView reservationMakerWindowish;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
  [self createMainMenu];

  theWindow = [[CPWindow alloc] initWithContentRect: CGRectMakeZero()
	                                  styleMask: CPBorderlessBridgeWindowMask];
  [theWindow orderFront:self];

  reservationMakerWindowish = [[CPView alloc] initWithFrame: [[theWindow contentView] frame]];
  [[theWindow contentView] addSubview: reservationMakerWindowish];

  allReservationViewerWindowish = [[CPView alloc] initWithFrame: [[theWindow contentView] frame]];
  [[theWindow contentView] addSubview: allReservationViewerWindowish];

  var cib = [[FakeMainWindowCib alloc] init];
  [cib loadUsingView: reservationMakerWindowish];
  [theWindow makeFirstResponder: [cib desiredFirstResponder]];

  cib = [[FakeAllReservationWindowCib alloc] init];
  [cib loadUsingView: allReservationViewerWindowish];

  [self activateReservationMaker]
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
  [reservationMakerWindowish setHidden:NO];
  [allReservationViewerWindowish setHidden:YES];
}

- (void) activateReservationViewer: (CPMenuItem) sender
{
  [reservationMakerWindowish setHidden:YES];
  [allReservationViewerWindowish setHidden:NO];
}

@end
