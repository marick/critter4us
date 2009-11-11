@import <AppKit/AppKit.j>
@import "../controller/TableViewingPageController.j"

@implementation PageControllerPVR : TableViewingPageController
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
