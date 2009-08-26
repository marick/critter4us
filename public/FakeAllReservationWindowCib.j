@import "Constants.j"
@import "ControllerCoordinator.j"

@implementation FakeAllReservationWindowCib : CPObject
{
}

- (void)loadUsingView: aView
{
  var optionsView = [[CPWebView alloc] initWithFrame: CGRectMake(10,30, 700,40)];
  [optionsView loadHTMLString:@"<b>Some text will go here!</b>" baseURL: nil];
  [aView addSubview: optionsView];
}


@end

