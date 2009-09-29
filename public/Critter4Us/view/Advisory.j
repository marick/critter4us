@import <AppKit/CPCollectionView.j>
@import "DebuggableCollectionView.j"

@implementation Advisory : CPScrollView
{
  CPTextField textField;
}

- (id) init
{
  var horizontalSpaceForText = 400;

  textField = [[CPTextField alloc] initWithFrame:
                                     CGRectMake(0, 0, horizontalSpaceForText, 1200)];
  [textfield setBackgroundColor: [CPColor greenColor]];
  [textfield setStringValue: "any good long line will do just fine I think."];
  [textfield setLineBreakMode: CPLineBreakByWordWrapping];

  self = [super initWithFrame:
                  CGRectMake(0, 0, horizontalSpaceForText + [CPScroller scrollerWidth], 200)];
  [self setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
  [self setAutohidesScrollers:NO];
  [[self contentView] setBackgroundColor: [CPColor yellowColor]];
  [self setDocumentView:textfield];

  [self wrapInWindow];
}

- (void) wrapInWindow
{
  var window = [[CPPanel alloc] initWithContentRect: [self bounds]
                                          styleMask: CPTitledWindowMask];
  [window setFloatingPanel:YES];
  [window setTitle:@"Advisory"];
  [window orderFront: self]; 
  [window setContentView: self];
}  

@end
