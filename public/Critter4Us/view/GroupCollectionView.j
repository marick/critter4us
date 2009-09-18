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
  var itemPrototype = [[GroupCollectionViewItem alloc] init];
  var button = [[GroupButton alloc]
                     initWithFrame: CGRectMakeZero()];
  [itemPrototype setView: button];
  [self setItemPrototype:itemPrototype];

  return self;
}

@end

@implementation GroupCollectionViewItem : CPCollectionViewItem
{
}

- (void)setRepresentedObject:(id)aGroup
{
  [super setRepresentedObject aGroup];
  var title = [aGroup name];
  if ([title isEqual: ""])
  {
    title = "* No procedures chosen *";
  }
  [[self view] setTitle: title];
}

@end


@implementation GroupButton : CPButton
{
}

- (void)setRepresentedObject:(id)aGroup
{
  // This is required by the CPCollectionView protocol.
}
