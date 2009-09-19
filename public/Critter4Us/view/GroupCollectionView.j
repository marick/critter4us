@import <AppKit/CPCollectionView.j>
@import "DebuggableCollectionView.j"
@import "../model/Group.j"

@implementation GroupCollectionView : CPCollectionView
{
  CPInteger currentIndex;
  CPString defaultName;
}

- (id) initWithFrame: rect
{
  self = [super initWithFrame: rect];
  [self setMinItemSize:CGSizeMake(300, TextLineHeight)];
  [self setMaxItemSize:CGSizeMake(300, TextLineHeight)];
  var itemPrototype = [[NamedObjectCollectionViewItem alloc] init];
  var button = [[ConformingButton alloc]
                     initWithFrame: CGRectMakeZero()];
  [itemPrototype setView: button];
  [self setItemPrototype:itemPrototype];
  [self becomeEmpty];
  defaultName = '';
  return self;
}

- (void) setDefaultName: aString
{
  defaultName = aString;
}

- (CPString) defaultName
{
  return defaultName;
}

- (void) becomeEmpty
{
  [self setContent: []];
  currentIndex = -1;
}

- (void) addNamedObjectToContent: anObject
{
  var content = [[self content] copy];
  [content addObject: anObject];
  [self setContent: content];
  currentIndex ++;
}

- (id) currentRepresentedObject
{
  return [[self content] objectAtIndex: currentIndex];
}

- (void) currentNameHasChanged
{
  [[[self items] objectAtIndex: currentIndex] refreshButtonTitle];
}

// overrides

- (CPCollectionViewItem) newItemForRepresentedObject: (id) anObject
{
  var item = [super newItemForRepresentedObject: anObject];
  [item setDefaultNameSource: self]; // See note in NamedObjectCollectionView
  [item refreshButtonTitle];
  return item;
}


@end

@implementation NamedObjectCollectionViewItem : CPCollectionViewItem
{
  // The implementation of CollectionViewItem#collectionView
  // doesn't return the collectionview, though I don't know why.
  // Therefore I'm using a separate way of getting at it.
  // TODO: make a test for this, try it with later versions of Cappuccino.
  (GroupCollectionView) defaultNameSource;
}


-(void) setDefaultNameSource: aCollectionView
{
  defaultNameSource = aCollectionView;
}

-(GroupCollectionView) defaultNameSource
{
  return defaultNameSource;
}


- (void) refreshButtonTitle
{
  var title = [[self representedObject] name];
  if ([title isEqual: ""])
  {
    title = [[self defaultNameSource] defaultName];
  }
  [[self view] setTitle: title];
}

@end


@implementation ConformingButton : CPButton
{
}

- (void)setRepresentedObject:(id)aGroup
{
  // This is required by the CPCollectionView protocol.
}

@end
