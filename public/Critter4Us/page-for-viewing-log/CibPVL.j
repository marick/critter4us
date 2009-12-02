@import "PageControllerPVL.j"

@implementation CibPVL : TableViewingCib
{
  
}

- (id) makePageControllerUnder: owner
{
  var pageController = [[PageControllerPVL alloc] init];
  owner.pvlPageController = pageController;	
  return pageController;
}

@end

