@import <AppKit/CPPanel.j>


// This is a separate class from TimesliceChangingControl because
// CPPanels can't be instantiated without a window system.

@implementation TimesliceChangingPopup : CPPanel
{
}

- (id) initAtX: x y: y
{
  var rect = CGRectMake(x, y, 300, 150);
  self = [self initWithContentRect: rect styleMask: CPTitledWindowMask];
  [self setFloatingPanel:YES];
  [self setTitle:@"Change Date and Time"];
  [self orderOut: self]; 
  return self;
}


@end
