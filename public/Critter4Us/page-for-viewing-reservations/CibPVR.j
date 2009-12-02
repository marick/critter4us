@import "../util/Constants.j"
@import "../cib/HtmlViewingCib.j"
@import "PageControllerPVR.j"

@implementation CibPVR : HtmlViewingCib
{
  
}

- (id) makePageControllerUnder: owner
{
  var pageController = [[PageControllerPVR alloc] init];
  owner.pvrPageController = pageController;	
  return pageController;
}

@end

