@import <AppKit/AppKit.j>

// Override methods to add logging.

@implementation DebuggableCollectionView : CPCollectionView
{
}

-(CPCollectionViewItem)xxx_newItemForRepresentedObject:(id)anObject
{
  //  alert("new item for represented object: " + anObject);
  var item = [super newItemForRepresentedObject: anObject];
  //  alert("new item is: " + item);
  return item;
}

-(void) xxx_setItemPrototype: (CPView)anItem
{
  //  alert('setting item prototype: ' + anItem);
  [super setItemPrototype: anItem];
}

-(void)xxx_setContent: anArray
{
  alert("setting content to " + [anArray description]);
  alert("previous content is " + _content);
  [super setContent: anArray];
}

-(void) xxx_reloadContent
{
  alert("reload content _items starting with " + _items);
  alert("reload content _content is: " + _content);
  alert("reload content _itemData is: " + _itemData);
  [super reloadContent];
}

@end
