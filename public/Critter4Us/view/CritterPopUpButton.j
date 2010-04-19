@import <AppKit/AppKit.j>

@implementation CritterPopUpButton : CPPopUpButton
{
  
}


- (String) selectedItemTitle
{
  return [[self selectedItem] title];
}

@end
