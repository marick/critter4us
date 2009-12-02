@import "PageControllerPVL.j"

@implementation CibPVL : HtmlViewingCib
{
  
}

- (id) makePageControllerUnder: owner
{
  var pageController = [[PageControllerPVL alloc] init];
  owner.pvlPageController = pageController;	
  return pageController;
}

@end

