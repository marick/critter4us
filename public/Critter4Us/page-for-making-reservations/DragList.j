@import <AppKit/AppKit.j>
@import "Constants.j"

@implementation DragList : CPPanel
{
  CPArray content;
  CPDragType dragType;
}

- (id)initWithTitle: title atX: x backgroundColor: color content: someContent
             ofType: someDragType
{
  dragType = someDragType;
  content = someContent;
  
  self = [self placePanelAtX: x withTitle: title];
  if (! self) return nil;
        
  var bounds = [self usableArea];
  var collectionView = [self placeCollectionViewAt: bounds];
        
  [collectionView setDelegate:self]; // TODO get rid of this?
  [self describeItemsTo: collectionView];
  [self surround: collectionView withScrollViewColored: color];
  
  [collectionView setContent:content]; // TODO delete

  return self;
}

- (CPData)collectionView:(CPCollectionView)aCollectionView dataForItemsAtIndexes:(CPIndexSet)indices forType:(CPString)aType
{
    return [CPKeyedArchiver archivedDataWithRootObject:[content objectAtIndex:[indices firstIndex]]];
}

- (CPArray)collectionView:(CPCollectionView)aCollectionView dragTypesForItemsAtIndexes:(CPIndexSet)indices
{
    return [dragType];
}


// Util

- (DragList) placePanelAtX: x withTitle: title
{
  var panelRect = CGRectMake(x, WindowTops, DragSourceWindowWidth,
                             DragSourceWindowHeight);
  self = [self initWithContentRect: panelRect
                         styleMask: CPHUDBackgroundWindowMask | CPResizableWindowMask];
  if (! self) return nil;

  [self setFloatingPanel:YES];
  [self setTitle:title];
  return self;
}

- (CPRect) usableArea
{
  var contentView = [self contentView];
  var bounds = [contentView bounds];
  bounds.size.height -= WindowBottomMargin;
  return bounds;
}

- (CPCollectionView) placeCollectionViewAt: rect
{
    var collectionView = [[CPCollectionView alloc] initWithFrame:rect];
        
    [collectionView setAutoresizingMask:CPViewWidthSizable];
    return collectionView;
}

- (void) describeItemsTo: (CPCollectionView) collectionView
{
  var itemPrototype = [[CPCollectionViewItem alloc] init];
        
  [itemPrototype setView:[[DragListItemView alloc] initWithFrame:CGRectMakeZero()]];
  [collectionView setItemPrototype:itemPrototype];

  [collectionView setMinItemSize:CGSizeMake(CompleteTextLineWidth, TextLineHeight)];
  [collectionView setMaxItemSize:CGSizeMake(CompleteTextLineWidth, TextLineHeight)];
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

@implementation DragListItemView : CPTextField
{
}

- (void)setSelected:(BOOL)isSelected
{
    [self setBackgroundColor:isSelected ? [CPColor grayColor] : nil];
}

- (void)setRepresentedObject:(id)anObject
{
  [self setStringValue: anObject];
}

@end
