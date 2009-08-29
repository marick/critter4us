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

- (void) appear
{
	[pageView setHidden:NO];
	alert("This should reload data");
}

- (void) disappear
{
	[pageView setHidden:YES];
}




@end