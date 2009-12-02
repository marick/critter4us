@import <AppKit/AppKit.j>
@import "../controller/PageController.j"

@implementation PageControllerPVL : PageController
{
}

- (void) appear
{
  [super appear];
  var text = [[Logger defaultLogger] text];
  var surrounded = "<pre>" + text + "</pre>";
  [table loadHTMLString: surrounded  baseURL: nil];
}

@end
