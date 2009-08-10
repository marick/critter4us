@import "AwakeningObject.j"

@implementation ResultController : AwakeningObject
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
  [NotificationCenter
   addObserver: self
   selector: @selector(activateLink:)
   name: NewReservationNews
   object: nil];
}

- (void) activateLink: aNotification
{
  [containingView setHidden:NO];
  var number = [aNotification object];
  var href = "/reservation/" + number;
  var message = "Click to view the reservation in a new window.";
  [link loadHTMLString:@"<a href='" + href + "' target=\"_blank\">" + message + "</a>"
               baseURL: nil];

}

@end