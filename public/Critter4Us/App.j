@import <AppKit/AppKit.j>
@import "MainMenuCib.j"
@import "util/Logger.j"
@import "view/Advisor.j"
@import "view/Spinner.j"
@import "page-for-making-reservations/CibPMR.j"
@import "page-for-viewing-reservations/CibPVR.j"
@import "page-for-deleting-animals/CibPDA.j"
@import "page-for-viewing-log/CibPVL.j"


// This pure-javascript object is used to make forwarding from HTML
// onclick methods simpler than hand-coding the expansion of Objective-J into 
// objj_msgSend(...) gobbledeegook.

AppForwarder = {}
AppForwarder.edit = function(reservationId) {
  [[CPApp delegate] editReservation: reservationId];
};
AppForwarder.copy = function(reservationId) {
  [[CPApp delegate] copyReservation: reservationId];
};


@implementation App : CPObject
{
  CPWindow theWindow;
  CPObject pvrPageController;
  CPObject pmrPageController;
  CPObject pdaPageController;
  CPObject pvlPageController;

  CPArray allPageControllers;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
  theWindow = [[CPWindow alloc] initWithContentRect: CGRectMakeZero()
                                          styleMask: CPBorderlessBridgeWindowMask];
  [theWindow orderFront:self];

  [self createMainMenu];
  [[Advisor alloc] init];
  [[Spinner alloc] initWithin: theWindow];
  [self createPage: CibPMR];
  [self createPage: CibPVR];
  [self createPage: CibPDA];
  [self createPage: CibPVL];
  [self initializationIndependentOfUI]

  [self activateReservationMaker: self];
}

-(void) initializationIndependentOfUI
{
  allPageControllers = [pvrPageController, pmrPageController, pdaPageController, pvlPageController];
}

-(void) createPage: klass
{
  [[klass alloc] instantiatePageInWindow: theWindow withOwner: self];
}

-(void)createMainMenu
{
  [[MainMenuCib alloc] initializeWithOwner: self];
}

- (void) foreground: aPageController
{
  for (var i=0; i < [allPageControllers count]; i++)
  {
    if (allPageControllers[i] != aPageController)
      [allPageControllers[i] disappear];
  }
  [aPageController appear];
}


- (void) activateReservationViewer: (CPMenuItem) sender
{
  [self foreground: pvrPageController];
}

- (void) activateLogViewer: (CPMenuItem) sender
{
  [self foreground: pvlPageController];
}

- (void) activateAnimalDeleter: (CPMenuItem) sender
{
  [self foreground: pdaPageController];
}

- (void) activateReservationMaker: (CPMenuItem) sender
{
  [self foreground: pmrPageController];
}

- (void) editReservation: id
{
  [NotificationCenter postNotificationName: ModifyReservationNews
                                    object: id];
  [self activateReservationMaker: UnusedArgument];

}

- (void) copyReservation: id
{
  [NotificationCenter postNotificationName: CopyReservationNews
                                    object: id];
  [self activateReservationMaker: UnusedArgument];

}

@end

