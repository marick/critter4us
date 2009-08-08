@import "Controller.j"

@implementation ResultController : Controller
{
  // outlets
  CPWebView link;
  CPView containingView;
}

- (void) awakeFromCib
{
  if (awakened) return;
  [super awakeFromCib];

  [containingView setHidden:YES];
}

- (void) setUpNotifications
{
}

- (void) activateLink: aNotification
{
  //  [webView loadHTMLString:@"<a href=\"http://arxta.net\" target=\"_blank\">Click me!</a>" baseURL: nil];

}

@end
