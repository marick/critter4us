@import "PageController.j"

@implementation HtmlViewingPageController : PageController
{
  CPView table;
}

- (void) setUpNotifications
{
  [super setUpNotifications];
  [self notificationNamed: [self finishNotificationName]
                    calls: @selector(finishFetch:)];
}

- (void) appear
{
  [super appear]
  var tableHtml = [self fetchHTML];
}

- (CPString) finishNotificationName
{
  return "Subclass responsibility";
}

- (CPString) fetchHTML
{
  return "Subclass responsibility";
}

- (void) finishFetch: aNotification
{
   [table loadHTMLString: [aNotification object] baseURL: nil];
}

@end
