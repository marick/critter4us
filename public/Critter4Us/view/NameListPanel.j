@import <AppKit/AppKit.j>
@import "FloatingPanel.j"
@import "NamedObjectCollectionView.j"

@implementation NameListPanel : FloatingPanel
{
  CPCollectionView collectionView;
}

- (id) initWithRect: panelRect title: aTitle color: aColor
{
  [self initWithRect: panelRect title: aTitle]
  [self addCollectionWithBackgroundColor: aColor]
  return self;
}

// Util


- (void) addCollectionWithBackgroundColor: color 
{
  var bounds = [self usableArea];
  collectionView = [[NamedObjectCollectionView alloc] initWithFrame:bounds];
        
  [collectionView placeScrollablyWithin: [self contentView]
                    withBackgroundColor: color];
}

@end


