@import <AppKit/AppKit.j>
@import "../util/Constants.j"

@implementation DropTarget : CPView
{
  CPColor subtleHint;
  CPColor strongHint;
  CPDragType dragType;
  CPCollectionView collectionView;
  id controller;
}

-(void) setNormalColor: aNormalColor andHoverColor: aHoverColor
{
  subtleHint = aNormalColor;
  strongHint = aHoverColor;
  [self giveSubtleHint];
}

- (void) surround: aCollectionView
{
  collectionView = aCollectionView;

  var scrollView = [[CPScrollView alloc] initWithFrame: [self bounds]];
  [self addSubview: scrollView];
        
  [scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
  [scrollView setAutohidesScrollers:YES];

  var collectionViewFrame = [[scrollView contentView] bounds];
;
  [collectionView setFrame: collectionViewFrame];
  [collectionView setMinItemSize:CGSizeMake(TruncatedTextLineWidth, TextLineHeight)];
  [collectionView setMaxItemSize:CGSizeMake(TruncatedTextLineWidth, TextLineHeight)];
  [scrollView setDocumentView:collectionView];
}

- (void) giveSubtleHint
{
  [self setBackgroundColor: subtleHint];
}

- (void) giveStrongHint
{
  [self setBackgroundColor: strongHint];
}

- (CPBoolean) prepareForDragOperation: (CPDraggingInfo) aSender
{
  var data = [self dataWithin: aSender];        
  var result = [controller canBeDropped: data];
  return result;
}

- (CPBoolean)performDragOperation:(CPDraggingInfo)aSender
{
  var data = [[aSender draggingPasteboard] dataForType:dragType];
  var result = [controller receiveNewItem: data];
  return result;
}

- (CPDragOperation)draggingEntered:(CPDraggingInfo)aSender
{
  [self giveStrongHint];
  // TODO: return value CPDragOperationCopy should have. Don't know why
  // definition is inaccessible. In current Cappuccino, value is ignored
  // anyway.
  return 1<<1;
}

- (void)draggingExited:(CPDraggingInfo)aSender
{
  [self giveSubtleHint];
}

- (void) concludeDragOperation: (id) aSender
{
  [self giveSubtleHint];
}

- (void) stopObserving
{
  // Required by ScenarioTestCase.setup
}


-(id) dataWithin: (CPDraggingInfo) aSender
{
  return [[aSender draggingPasteboard] dataForType:dragType];
}

@end
