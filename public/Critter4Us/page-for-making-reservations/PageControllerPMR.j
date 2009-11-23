@import "../controller/PageController.j"

@implementation PageControllerPMR : PageController
{
}

- (void) init
{
  self = [super init];
  [self notificationNamed: NewAdvisorPanelOnPageNews
                    calls: @selector(addAdvisorPanelControllerFromNotification:)];
  [self notificationNamed: ClosedAdvisorPanelOnPageNews
                    calls: @selector(removeAdvisorPanelControllerFromNotification:)];
  return self;
}

- (void) addAdvisorPanelControllerFromNotification: aNotification
{
  [[self panelControllers] addObject: [aNotification object]];
}

- (void) removeAdvisorPanelControllerFromNotification: aNotification
{
  [[self panelControllers] removeObject: [aNotification object]];
}

@end
