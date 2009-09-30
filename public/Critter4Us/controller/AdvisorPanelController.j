@import "PanelController.j"

@implementation AdvisorPanelController : PanelController
{
}


- (void) setUpNotifications
{
  [self notificationNamed: AdvisoriesAreIrrelevantNews
                    calls: @selector(finishUp:)];
}

- (void) finishUp: aNotification
{
  [panel performClose: self];
  [self stopObserving];
}


@end
