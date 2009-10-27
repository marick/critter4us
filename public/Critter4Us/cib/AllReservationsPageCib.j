@import "../util/Constants.j"
@import "../controller/AllReservationsPageController.j"

@implementation AllReservationsPageCib : CPObject
{
  
}

- (void)instantiatePageInWindow: (CPWindow) window withOwner: (CPObject) owner
{
	var containingView = [window contentView];
	
	var pageView = [[CPView alloc] initWithFrame: [containingView frame]];
  [containingView addSubview: pageView];
	[pageView setHidden:YES];

	var table = [[CPWebView alloc] initWithFrame: CGRectMake(10,30, 970,500)];
  [pageView addSubview: table];

	var pageController = [[AllReservationsPageController alloc] init];
	pageController.pageView = pageView;
	pageController.table = table;
	owner.allReservationsPageController = pageController;	
	
        var persistentStore = [[PersistentStore alloc] init];
        persistentStore.network = [[NetworkConnection alloc] init];
        pageController.persistentStore = persistentStore;

	[pageController awakeFromCib];
}

@end

