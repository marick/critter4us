@import <AppKit/AppKit.j>
@import "../controller/HtmlViewingPageController.j"

@implementation PageControllerPVR : HtmlViewingPageController
{
  CritterPopUpButton daySelection;
}

- (void) changeDays: sender
{
  [self fetchHTML];
}

- (CPString) finishNotificationName
{
  return AllReservationsHtmlNews;
}

- (CPString) fetchHTML
{
  [persistentStore allReservationsHtmlForPastDays: [daySelection titleOfSelectedItem]];
}

@end
