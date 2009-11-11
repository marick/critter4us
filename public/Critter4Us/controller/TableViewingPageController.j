@import <AppKit/AppKit.j>
@import "../util/AwakeningObject.j"

@implementation TableViewingPageController : AwakeningObject
{
  CPView pageView;
  CPView table;
  PersistentStore persistentStore;
}

- (void) setUpNotifications
{
  [super setUpNotifications];
  [self notificationNamed: [self finishNotificationName]
                    calls: @selector(finishFetch:)];
}

- (void) appear
{
  [pageView setHidden:NO];
	
  var tableHtml = [self fetchHTML];
}

- (CPString) startFetch
{
  return "Subclass responsibility";
}

- (void) finishFetch: aNotification
{
   [table loadHTMLString: [aNotification object] baseURL: nil];
}

- (void) disappear
{
  [pageView setHidden:YES];
}

@end
