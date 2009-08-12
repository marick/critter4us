@import "AwakeningObject.j"

@implementation ResultController : AwakeningObject
{
  // outlets
  CPWebView link;
  CPView containingView;
}

// TODO: switch superclass so these are available
- (void) hideViews
{
  [containingView setHidden:YES];
}

- (void) showViews
{
  [containingView setHidden:NO];
}



- (void) offerReservationView: id
{
  var href = "/reservation/" + id;
  var message = "Click to view the reservation in a new window.";
  [link loadHTMLString:@"<a href='" + href + "' target=\"_blank\">" + message + "</a>"
               baseURL: nil];

}

@end
