@import <AppKit/AppKit.j>
@import "../controller/TableViewingPageController.j"

@implementation PageControllerPVR : TableViewingPageController
{
}

- (CPString) fetchHTML
{
  return [persistentStore pendingReservationTableAsHtml];
}


@end
