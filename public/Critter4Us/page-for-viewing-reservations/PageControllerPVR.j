@import <AppKit/AppKit.j>
@import "../controller/HtmlViewingPageController.j"

@implementation PageControllerPVR : HtmlViewingPageController
{
}

- (CPString) finishNotificationName
{
  return AllReservationsHtmlNews;
}

- (CPString) fetchHTML
{
  [persistentStore allReservationsHtml];
}

@end
