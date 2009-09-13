@import <AppKit/CPCollectionView.j>
@import "DebuggableCollectionView.j"

@implementation NamedObjectCollectionView : DebuggableCollectionView
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

