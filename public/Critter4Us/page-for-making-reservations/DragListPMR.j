@import <AppKit/AppKit.j>
@import "ConstantsPMR.j"
// @import "../view/SummaryShowingCollectionViewItem.j"
@import "../view/NamedObjectCollectionView.j"

@implementation DragListPMR : CPPanel
{
  CPDragType dragType;
}


- (id) initWithContentRect: panelRect
{
  self = [self initWithContentRect: panelRect
                         styleMask: CPHUDBackgroundWindowMask | CPResizableWindowMask];
  [self setFloatingPanel:YES];
  return self;
}

- (CPCollectionView)addCollectionViewSupplying: someDragType signalingWith: color 
{
  dragType = someDragType;
  
  var bounds = [self usableArea];
  var collectionView = [[NamedObjectCollectionView alloc] initWithFrame:bounds];
        
  [self surround: collectionView withScrollViewColored: color];

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


- (void) surround: collectionView withScrollViewColored: color
{
    var scrollView = [[CPScrollView alloc] initWithFrame: [collectionView bounds]];
        
    [scrollView setDocumentView:collectionView];
    [scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
    [scrollView setAutohidesScrollers:YES];

    [[scrollView contentView] setBackgroundColor:color];

    [[self contentView] addSubview:scrollView];
}

@end


// TODO: this can be deleted.
@implementation DragListItemViewPMR : CPTextField
{
}

- (void)setSelected:(BOOL)isSelected
{
    [self setBackgroundColor:isSelected ? [CPColor grayColor] : nil];
}

- (void)setRepresentedObject:(id)anObject
{
  [self setStringValue: [anObject summary]];
}

@end


