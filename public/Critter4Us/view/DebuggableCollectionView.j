@import <AppKit/AppKit.j>

// Override methods to add logging.

@implementation DebuggableCollectionView : CPCollectionView
{
}

-(CPCollectionViewItem)xxx_newItemForRepresentedObject:(id)anObject
{
  alert("new item for represented object IN: " + [anObject description]);
  var item = [super newItemForRepresentedObject: anObject];
  alert("new item OUT is: " + [item description]);
  return item;
}

-(void) xxx_setItemPrototype: (CPView)anItem
{
  alert('setting item prototype: ' + [anItem description]);
  [super setItemPrototype: anItem];
  alert('saved data is ' + _itemData);
}

-(void)xxx_setContent: anArray
{
  alert("setting content to " + [anArray description]);
  alert("previous content is " + [_content description]);
  [super setContent: anArray];
}

-(void) xxx_reloadContent
{
  alert("reload content _items starting with " + [_items description]);
  alert("reload content _content is: " + [_content description]);
  alert("reload content _itemData is: " + _itemData);
  [super reloadContent];
}

@end
