@import "../util/Constants.j"

@implementation HtmlViewingCib : CPObject
{
  CPView pageView;
}

- (void)instantiatePageInWindow: (CPWindow) window withOwner: (CPObject) owner
{
  var containingView = [window contentView];
	
  pageView = [[CPView alloc] initWithFrame: [containingView frame]];
  [containingView addSubview: pageView];
  [pageView setHidden:YES];

  var table = [[CPWebView alloc] initWithFrame: CGRectMake(10,30+[self tableVerticalOffset],
                                                           970,500)];
  [pageView addSubview: table];

  var pageController = [self makePageControllerUnder: owner];
  pageController.pageView = pageView;
  pageController.table = table;
	
  pageController.persistentStore = [PersistentStore sharedPersistentStore];

  [pageController awakeFromCib];
}

- (id) tableVerticalOffset
{
  return 0;
}

- (id) makePageControllerUnder: owner
{
  [self subclassResponsibility];
}

@end

