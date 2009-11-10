@import "../util/Constants.j"
@import "../cib/TableViewingCib.j"
@import "PageControllerPVR.j"

@implementation CibPVR : TableViewingCib
{
  
}

- (id) makePageControllerUnder: owner
{
  var pageController = [[PageControllerPVR alloc] init];
  owner.pvrPageController = pageController;	
  return pageController;
}

@end

