@import <AppKit/CPPanel.j>


// Experimenting with having subclasses manage their own positions as
// an alternative to having giant Cib-like bundles o' code do that
// work.

@implementation DateTimeEditingPanel : CPPanel
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
