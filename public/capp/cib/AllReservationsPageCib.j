@import "Constants.j"
@import "AllReservationsPageController.j"

@implementation AllReservationsPageCib : CPObject
{
}

- (void)instantiatePageInWindow: (CPWindow) window withOwner: (CPObject) owner
{
	var containingView = [window contentView];
	var pageView = [[CPView alloc] initWithFrame: [containingView frame]];
  [containingView addSubview: pageView];

	var pageController = [[AllReservationsPageController alloc] init];
	pageController.pageView = pageView;
	owner.allReservationsPageController = pageController;
	
	[pageView setHidden:YES];
}

@end

