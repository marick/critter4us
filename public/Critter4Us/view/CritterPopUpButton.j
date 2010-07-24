@import <AppKit/AppKit.j>

@implementation CritterPopUpButton : CPPopUpButton
{
  
}

// Todo: No longer needed. Replace with titleOfSelectedItem
- (String) selectedItemTitle
{
  return [[self selectedItem] title];
}

@end
