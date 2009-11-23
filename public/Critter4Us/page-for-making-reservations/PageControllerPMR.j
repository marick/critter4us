@import "../controller/PageController.j"

@implementation PageControllerPMR : PageController
{
}

- (void) init
{
  self = [super init];
  [self notificationNamed: NewPanelOnPageNews
                    calls: @selector(addPanelControllerFromNotification:)];
  [self notificationNamed: ClosedPanelOnPageNews
                    calls: @selector(removePanelControllerFromNotification:)];
  return self;
}

- (void) addPanelControllerFromNotification: aNotification
{
  [[self panelControllers] addObject: [aNotification object]];
}

- (void) removePanelControllerFromNotification: aNotification
{
  [[self panelControllers] removeObject: [aNotification object]];
}

@end
