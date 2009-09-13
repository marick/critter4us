@import <AppKit/AppKit.j>
@import "../util/Constants.j"

@implementation DropTarget : CPView
{
  CPCollectionView collectionView;
  id controller;
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


@end
