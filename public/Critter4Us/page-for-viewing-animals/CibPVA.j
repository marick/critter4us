@import "../util/Constants.j"
@import "../cib/TableViewingCib.j"
@import "PageControllerPVA.j"

@implementation CibPVA : TableViewingCib
{
}

- (id) makePageControllerUnder: owner
{
  var pageController = [[PageControllerPVA alloc] init];
  owner.pvaPageController = pageController;	
  return pageController;
}

@end

