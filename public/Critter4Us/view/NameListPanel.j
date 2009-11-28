@import <AppKit/AppKit.j>
@import "NamedObjectCollectionView.j"

@implementation NameListPanel : CPPanel
{
  CPCollectionView collectionView;
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
  var panelRect = CGRectMake(x, y, SourceWindowWidth,
                             SourceWindowHeight);
  [self initWithContentRect: panelRect];
  [self setTitle: aTitle];
  [self orderFront: self]; // TODO: delete when page layout done.
  [self addCollectionWithBackgroundColor: aColor]
  return self;
}

// Util


- (void) addCollectionWithBackgroundColor: color 
{
  var bounds = [self usableArea];
  collectionView = [[NamedObjectCollectionView alloc] initWithFrame:bounds];
        
  [collectionView placeScrollablyWithin: [self contentView]
                    withBackgroundColor: color];
}


- (CPRect) usableArea
{
  var contentView = [self contentView];
  var bounds = [contentView bounds];
  bounds.size.height -= WindowBottomMargin;
  return bounds;
}

@end


