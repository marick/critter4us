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
  [self addReportsSubmenu];
  [self addDebugSubmenu];
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
  [self addMenuItemwithTitle: "Add Animals..."
                      action: @selector(activateAnimalAdder:)
               keyEquivalent: "A"
                       under: animalsMenu];
  [self addMenuItemwithTitle: "Take Animals Out of Service..."
                      action: @selector(activateAnimalDeleter:)
               keyEquivalent: "T"
                       under: animalsMenu];
}

- (void) addReportsSubmenu
{
  var menu = [self submenuNamed: "Reports" below: mainMenu];
  [self addMenuItemwithTitle: "All Animals and Procedures By Date"
                      action: @selector(activateReportAllByDate:)
               keyEquivalent: "P"
                       under: menu];
}


- (void) addDebugSubmenu
{
  var debugMenu = [self submenuNamed: "Debug" below: mainMenu];
  [self addMenuItemwithTitle: "View Log"
                      action: @selector(activateLogViewer:)
               keyEquivalent: "L"
                       under: debugMenu];
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
