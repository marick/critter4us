@import <AppKit/AppKit.j>
@import "../controller/TableViewingPageController.j"

@implementation PageControllerPVA : TableViewingPageController
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
