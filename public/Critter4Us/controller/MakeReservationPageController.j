@import <AppKit/AppKit.j>

@implementation MakeReservationPageController : CPObject
{
	CPView pageView;
	CPResesponder desiredFirstResponder;
}

- (void) setDesiredFirstResponder: (CPResponder) aResponder
{
	desiredFirstResponder = aResponder;
}

- (void) appear
{
	[pageView setHidden:NO];
}

- (void) windowNeedsFirstResponder: (CPWindow) theWindow
{
	[theWindow makeFirstResponder: desiredFirstResponder];
}

- (void) disappear
{
	[pageView setHidden:YES];
}

@end