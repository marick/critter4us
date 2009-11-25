@import "PanelController.j"

@implementation AdvisorPanelController : PanelController
{
}

-(id) initWithPanel: aPanel
{
  [super initWithPanel: aPanel];
  [NotificationCenter postNotificationName: NewAdvisorPanelOnPageNews object: self];
  return self;
}

-(CPBoolean) windowShouldClose: aNotification
{
  [NotificationCenter postNotificationName: ClosedAdvisorPanelOnPageNews object: self];
  return YES;
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
