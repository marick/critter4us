@import <AppKit/AppKit.j>
@implementation DragList : CPPanel
{
  CPArray content;
  CPDragType dragType;
}

- (id)initWithTitle: title atX: x backgroundColor: color content: someContent ofType: someDragType
{
  dragType = someDragType;
    self = [self initWithContentRect:CGRectMake(x, WindowTops, DragSourceWindowWidth, DragSourceWindowHeight) styleMask:CPHUDBackgroundWindowMask | CPResizableWindowMask];

    if (self)
    {
        [self setTitle:title];
        [self setFloatingPanel:YES];
        
        var contentView = [self contentView],
            bounds = [contentView bounds];
        
        bounds.size.height -= WindowBottomMargin;

        var collectionView = [[CPCollectionView alloc] initWithFrame:bounds];
        
        [collectionView setAutoresizingMask:CPViewWidthSizable];
        [collectionView setMinItemSize:CGSizeMake(CompleteTextLineWidth, TextLineHeight)];
        [collectionView setMaxItemSize:CGSizeMake(CompleteTextLineWidth, TextLineHeight)];
        [collectionView setDelegate:self];
        
        var itemPrototype = [[CPCollectionViewItem alloc] init];
        
        [itemPrototype setView:[[DragListItemView alloc] initWithFrame:CGRectMakeZero()]];
        
        [collectionView setItemPrototype:itemPrototype];
        
        var scrollView = [[CPScrollView alloc] initWithFrame:bounds];
        
        [scrollView setDocumentView:collectionView];
        [scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        [scrollView setAutohidesScrollers:YES];

        [[scrollView contentView] setBackgroundColor:color];

        [contentView addSubview:scrollView];
        
        content = someContent;
        [collectionView setContent:content];
    }

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



