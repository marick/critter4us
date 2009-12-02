@import <AppKit/AppKit.j>
@import "../controller/HtmlViewingPageController.j"

@implementation PageControllerPVR : HtmlViewingPageController
{
}

- (CPString) finishNotificationName
{
  return ReservationTableRetrievedNews;
}

- (CPString) fetchHTML
{
  [persistentStore pendingReservationTableAsHtml];
}

@end
