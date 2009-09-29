@import <AppKit/CPCollectionView.j>
@import "DebuggableCollectionView.j"

@implementation Advisory : CPScrollView
{
  CPTextField textField;
}

- (id) init
{
  var horizontalSpaceForText = 400;
  var verticalSpaceForText = 120;
  var advisoryColor = [CPColor colorWithRed: 0.99 green: 0.98 blue: 0.70 alpha: 1.0];

  textField = [[CPTextField alloc] initWithFrame:
                                     CGRectMake(0, 0, horizontalSpaceForText, 1200)];
  [textField setBackgroundColor: advisoryColor];
  [textField setStringValue: "any good long line will do just fine I think."];
  [textField setLineBreakMode: CPLineBreakByWordWrapping];

  self = [super initWithFrame:
                  CGRectMake(0, 0, horizontalSpaceForText + [CPScroller scrollerWidth], verticalSpaceForText)];
  [self setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
  [self setAutohidesScrollers:NO];
  [self setDocumentView:textField];

  [self wrapInWindow];
}

- (void) wrapInWindow
{
  var rect = CGRectMake(600, 60, [self bounds].size.width, [self bounds].size.height);
  var window = [[CPPanel alloc] initWithContentRect: rect
                                          styleMask: CPTitledWindowMask|CPClosableWindowMask|CPMiniaturizableWindowMask|CPResizableWindowMask];
  [window setFloatingPanel:YES];
  [window setTitle:@"Advisory"];
  [window orderFront: self]; 
  [window setContentView: self];
}  

@end
