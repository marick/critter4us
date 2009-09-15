@import <AppKit/AppKit.j>
@import "NamedObjectCollectionView.j"

@implementation NameListPanel : CPPanel
{
}


- (id) initWithContentRect: panelRect
{
  self = [self initWithContentRect: panelRect
                         styleMask: CPHUDBackgroundWindowMask | CPResizableWindowMask];
  [self setFloatingPanel:YES];
  return self;
}

- (CPCollectionView)addCollectionWithBackgroundColor: color 
{
  var bounds = [self usableArea];
  var collectionView = [[NamedObjectCollectionView alloc] initWithFrame:bounds];
        
  [collectionView placeScrollablyWithin: [self contentView]
                    withBackgroundColor: color];

  return collectionView;
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


