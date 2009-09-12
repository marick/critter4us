@import <AppKit/AppKit.j>

@implementation SummaryShowingCollectionViewItem : CPCollectionViewItem
{
  
}

-(void) setRepresentedObject: (id) anObject
{
   if ([self representedObject] == anObject)
     return;
  // Can't call super because it assumes a view responds to 
  // setRepresentedObject.
  _representedObject = anObject; 

  [view setStringValue: [anObject summary]];
}



@end
