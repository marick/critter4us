@import <AppKit/CPCollectionView.j>
@import "DebuggableCollectionView.j"

@implementation NamedObjectCollectionView : CPCollectionView
{
}

- (id) initWithFrame: rect
{
  self = [super initWithFrame: rect];
  [self setAutoresizingMask:CPViewWidthSizable];
  var itemPrototype = [[CPCollectionViewItem alloc] init];
  [itemPrototype setView:[[NamedObjectCollectionItemView alloc] initWithFrame:CGRectMakeZero()]];
  [self setItemPrototype:itemPrototype];
  [self setMinItemSize:CGSizeMake(CompleteTextLineWidth, TextLineHeight)];
  [self setMaxItemSize:CGSizeMake(CompleteTextLineWidth, TextLineHeight)];

  return self;
}

- (void) setContent: (CPArray) anArray
{
  [super setContent: [anArray sortedArrayUsingSelector: @selector(compareNames:)]];
}

- (void) addContent: (CPArray) anArray
{
  [self setContent: [[self content] arrayByAddingObjectsFromArray: anArray]];
}
  
- (void) setSelectionIndexes: indexes
{
  var content = [self content];
  var removed = [content objectsAtIndexes: indexes];
  [content removeObjectsAtIndexes: indexes];
  [self setContent: content];
  [[self delegate] objectsRemoved: removed fromList: self];
}


// It's totally bogus that I have these two procedures.  The first is
// for the case where the collectionView has the known size and the
// scrollview goes around it. The second is for the case where there's
// a known frame and the collectionView is sized to fit within it.
- (void) placeScrollablyWithin: aView withBackgroundColor: color
{
    var scrollView = [[CPScrollView alloc] initWithFrame: [self bounds]];
        
    [scrollView setDocumentView:self];
    [scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
    [scrollView setAutohidesScrollers:YES];

    [[scrollView contentView] setBackgroundColor:color];
    [aView addSubview:scrollView];
}

- (void) placeWithin: aView withRect: aRect withBackgroundColor: aColor
{
  var scrollView = [[CPScrollView alloc] initWithFrame: aRect];
  [aView addSubview: scrollView];
        
  [scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
  [scrollView setAutohidesScrollers:YES];
  [[scrollView contentView] setBackgroundColor:aColor];

  var collectionViewFrame = [[scrollView contentView] bounds];
;
  [self setFrame: collectionViewFrame];
  [self setMinItemSize:CGSizeMake(TruncatedTextLineWidth, TextLineHeight)];
  [self setMaxItemSize:CGSizeMake(TruncatedTextLineWidth, TextLineHeight)];
  [scrollView setDocumentView: self];
}

@end

@implementation NamedObjectCollectionItemView : CPTextField
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

