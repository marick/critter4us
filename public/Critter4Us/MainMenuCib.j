@import <AppKit/AppKit.j>

@implementation MainMenuCib : CPObject
{
  CPObject owner;
  CPMenu mainMenu;
}

-(void) initializeWithOwner: anOwner
{
  owner = anOwner;
  
  [self addMainMenu];
  [self addReservationsSubmenu];
  [self addAnimalsSubmenu];
}

-(void)addMainMenu
{
  mainMenu = [[CPMenu alloc] initWithTitle:@"MainMenu"];
  //  [mainMenu setAutoEnablesItems:NO];
  [CPApp setMainMenu: mainMenu];
  [CPMenu setMenuBarVisible:YES];  
}

- (void) addReservationsSubmenu
{
  var reservationsMenu = [self submenuNamed: "Reservations" below: mainMenu];

  [self addMenuItemwithTitle: "Make a Reservation..."
                      action: @selector(activateReservationMaker:)
               keyEquivalent: "N"
                       under: reservationsMenu];

  [self addMenuItemwithTitle: "View All Reservations..."
                      action: @selector(activateReservationViewer:)
               keyEquivalent: "V"
                       under: reservationsMenu];
}

- (void) addAnimalsSubmenu
{
  var animalsMenu = [self submenuNamed: "Animals" below: mainMenu];
  [self addMenuItemwithTitle: "Take Animals Out of Service..."
                      action: @selector(activateAnimalDeleter:)
               keyEquivalent: "T"
                       under: animalsMenu];
}


// Util

-(CPMenu) submenuNamed: aName below: menu
{
  var submenu = [[CPMenu alloc] initWithTitle:aName];
  var submenuItem = [[CPMenuItem alloc] initWithTitle: aName 
                                           action: nil 
                                    keyEquivalent: nil];

  [submenuItem setSubmenu:submenu];
  [mainMenu addItem:submenuItem];
  return submenu;
}

-(void) addMenuItemwithTitle: aTitle action: anAction keyEquivalent: aKeyEquivalent
                       under: aMenu
{
  var item = [[CPMenuItem alloc] initWithTitle:aTitle
                                        action:anAction
                                 keyEquivalent:aKeyEquivalent];
  [item setTarget: owner];
  [item setKeyEquivalentModifierMask:CPControlKeyMask];  
  [aMenu addItem:item];
}


@end
