@import <AppKit/AppKit.j>
@import "../util/AwakeningObject.j"

@implementation TableViewingPageController : AwakeningObject
{
  CPView pageView;
  CPView table;
  PersistentStore persistentStore;
}

- (void) appear
{
  [pageView setHidden:NO];
	
  var tableHtml = [self fetchHTML];
  [table loadHTMLString:tableHtml baseURL: nil];
}

- (CPString) fetchHTML
{
  return "Subclass responsibility";
}

- (void) disappear
{
  [pageView setHidden:YES];
}

@end
