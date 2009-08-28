@import <AppKit/AppKit.j>

@implementation AllReservationsPageController : CPObject
{
	CPView pageView;
}

- (void)reloadData
{
  var randomView = [[CPWebView alloc] initWithFrame: CGRectMake(10,30, 700,40)];
  [randomView loadHTMLString:@"<b>Some text will go here!</b>" baseURL: nil];
  [pageView setSubviews: [randomView]];
}



@end