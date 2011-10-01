@import <AppKit/AppKit.j>

@implementation FloatingPanel : CPPanel
{
}

- (id) initWithContentRect: panelRect
{
  self = [self initWithContentRect: panelRect
                         styleMask: CPHUDBackgroundWindowMask | CPResizableWindowMask];
  [self setFloatingPanel:YES];
  return self;
}

- (id) initAtX: x y: y withTitle: aTitle color: aColor
{
  return [self initWithRect: CGRectMake(x, y, SourceWindowWidth, SourceWindowHeight)
                      title: aTitle
                      color: aColor];
}

- (id) initWithRect: panelRect title: aTitle
{
  [self initWithContentRect: panelRect];
  [self setTitle: aTitle];
  [self orderFront: self]; // TODO: delete when page layout done.
  return self;
}

// Util

- (CPRect) usableArea
{
  var contentView = [self contentView];
  var bounds = [contentView bounds];
  bounds.size.height -= WindowBottomMargin;
  return bounds;
}

@end


