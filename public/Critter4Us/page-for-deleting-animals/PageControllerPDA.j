@import <AppKit/AppKit.j>
@import "../controller/TableViewingPageController.j"

@implementation PageControllerPDA : TableViewingPageController
{
}

- (CPString) finishNotificationName
{
  return AnimalTableRetrievedNews;
}

- (CPString) fetchHTML
{
  [persistentStore animalTableAsHtml];
}


@end
