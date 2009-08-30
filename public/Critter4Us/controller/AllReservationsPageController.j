@import <AppKit/AppKit.j>
@import "../util/AwakeningObject.j"

@implementation AllReservationsPageController : AwakeningObject
{
	CPView pageView;
	CPView table;
	PersistentStore persistentStore;
}

- (void)reloadData // old
{
  [table loadHTMLString:@"<b>Some bew text will go here!</b>" baseURL: nil];
}

- (void) appear
{
	[pageView setHidden:NO];
	
	var tableHtml = [persistentStore pendingReservationTableAsHtml];
	[table loadHTMLString:tableHtml baseURL: nil];
}

- (void) disappear
{
	[pageView setHidden:YES];
}




@end
