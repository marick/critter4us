@import <Foundation/Foundation.j>
@import "FakeMainWindowCib.j"

@implementation App : CPObject
{
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
  [self createMainMenu];
  [FakeMainWindowCib load];
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



@end
