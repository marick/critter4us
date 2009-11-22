@import "../util/Constants.j"
@import "../cib/TableViewingCib.j"
@import "PageControllerPDA.j"

@implementation CibPDA : TableViewingCib
{
}

- (id) makePageControllerUnder: owner
{
  var pageController = [[PageControllerPDA alloc] init];
  owner.pdaPageController = pageController;	
  return pageController;
}

@end

