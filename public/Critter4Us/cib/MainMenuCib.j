@import <AppKit/AppKit.j>

@implementation MainMenuCib : CPObject
{
  CPObject owner;
  CPMenu mainMenu;
  CPMenu windowMenu;
  CPMenuItem reservationMakerMenuItem;
  CPMenuItem newReservationMakerMenuItem;
  CPMenuItem reservationViewerMenuItem;
}

-(void) initializeWithOwner: anOwner
{
  owner = anOwner;
  
  [self addMainMenu];
  [self addWindowMenuToMainMenu];
  [self addWindowMenuItemThatMakesReservation];
  [self addWindowMenuItemThatViewsAllReservations];
  [self separate];
  [self addWindowNewMenuItemThatMakesReservation];
}

-(void)addMainMenu
{
  mainMenu = [[CPMenu alloc] initWithTitle:@"MainMenu"];
  //  [mainMenu setAutoEnablesItems:NO];
  [CPApp setMainMenu: mainMenu];
  [CPMenu setMenuBarVisible:YES];  
}

-(void)addWindowMenuToMainMenu
{
  var windowMenuItem = [[CPMenuItem alloc] initWithTitle:@"Window" 
                                                  action:nil 
                                           keyEquivalent:nil];
  windowMenu = [[CPMenu alloc] initWithTitle:@"Window"];
  [windowMenuItem setSubmenu:windowMenu];
  [mainMenu addItem:windowMenuItem];
}


-(void)addWindowMenuItemThatMakesReservation
{
  reservationMakerMenuItem = 
       [self aWindowMenuItemwithTitle:@"Make a Reservation"
                               action:@selector(activateReservationMaker:)
                        keyEquivalent:'M'];
}

-(void)addWindowNewMenuItemThatMakesReservation
{
  newReservationMakerMenuItem = 
       [self aWindowMenuItemwithTitle:@"Mockup of New Way to Make a Reservation"
                               action:@selector(activateNewReservationMaker:)
                        keyEquivalent:'N'];
}

-(void)addWindowMenuItemThatViewsAllReservations
{
  reservationViewerMenuItem = 
      [self aWindowMenuItemwithTitle:@"View All Reservations" 
                              action:@selector(activateReservationViewer:) 
                       keyEquivalent:'V'];
}

// Util

-(void) separate
{
  [windowMenu addItem: [CPMenuItem separatorItem]];
}

-(CPMenuItem)aWindowMenuItemwithTitle: aTitle action: anAction keyEquivalent: aKeyEquivalent
{
  var item = [[CPMenuItem alloc] initWithTitle:aTitle
                                        action:anAction
                                 keyEquivalent:aKeyEquivalent];
  [item setTarget: owner];
  [item setKeyEquivalentModifierMask:CPControlKeyMask];  
  [windowMenu addItem:item];
  return item;
}

@end
