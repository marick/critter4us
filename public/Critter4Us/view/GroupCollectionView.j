@import <AppKit/CPCollectionView.j>
@import "DebuggableCollectionView.j"

@implementation GroupCollectionView : CPCollectionView
{
}

- (id) initWithFrame: rect
{
  self = [super initWithFrame: rect];
  [self setBackgroundColor: [CPColor redColor]];
  [self setMinItemSize:CGSizeMake(300, TextLineHeight)];
  [self setMaxItemSize:CGSizeMake(300, TextLineHeight)];
  var itemPrototype = [[CPCollectionViewItem alloc] init];
  var button = [[GroupButton alloc]
                     initWithFrame: CGRectMakeZero()];
  [itemPrototype setView: button];
  [collectionView setItemPrototype:itemPrototype];
  return self;
}

@end

@implementation GroupButton : CPButton
{
}

- (void)setRepresentedObject:(id)anObject
{
  //  alert("set represented object in" + [anObject description]);
  [self setTitle: anObject];
  //alert("set represented object out");
}
