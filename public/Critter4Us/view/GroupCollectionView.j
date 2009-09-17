@import <AppKit/CPCollectionView.j>
@import "DebuggableCollectionView.j"
@import "../model/Group.j"

@implementation GroupCollectionView : CPCollectionView
{
}

- (id) initWithFrame: rect
{
  self = [super initWithFrame: rect];
  [self setMinItemSize:CGSizeMake(300, TextLineHeight)];
  [self setMaxItemSize:CGSizeMake(300, TextLineHeight)];
  var itemPrototype = [[CPCollectionViewItem alloc] init];
  var button = [[GroupButton alloc]
                     initWithFrame: CGRectMakeZero()];
  [itemPrototype setView: button];
  [self setItemPrototype:itemPrototype];

  return self;
}

@end

@implementation GroupButton : CPButton
{
}

- (void)setRepresentedObject:(id)aGroup
{
  //  alert("set represented object in" + [anObject description]);
  [self setTitle: [aGroup name]];
  //alert("set represented object out");
}
