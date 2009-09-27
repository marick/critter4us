@import <AppKit/CPPanel.j>

@implementation DateChangingPanel : CPPanel
{
}

- (id) initAtX: x y: y
{
  var rect = CGRectMake(x, y, 300, 150);
  self = [self initWithContentRect: rect styleMask: CPTitledWindowMask];
  [self setFloatingPanel:YES];
  [self setTitle:@"Change Date and Time"];
  [self orderFront: self]; // TODO: delete when page layout done.
  return self;
}


@end
