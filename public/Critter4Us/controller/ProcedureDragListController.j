@import <AppKit/AppKit.j>
@import "../util/AwakeningObject.j"

@implementation ProcedureDragListController : CPWindowController
{
  // The use of this instance variable, rather than [self window] is a 
  // crutch to help mock-style tests.
  CPPanel window;
  CPPanel procedureListView;
}

-(void) initWithWindow: (CPWindow) aWindow
{
  self = [super initWithWindow: aWindow];
  window = [self window];
  return self;
}

-(void) awakeFromCib
{
  // [dragTargetView setBackgroundColor: [CPColor whiteColor]];
  [window setDelegate: self];
}

- (void) stopObserving
{
  // TODO: Make this AwakeningWindowController? Protocol?
  [[CPNotificationCenter defaultCenter] removeObserver: self];
}


- (CPData)collectionView:(CPCollectionView)aCollectionView dataForItemsAtIndexes:(CPIndexSet)indices forType:(CPString)aType
{
  alert("here's drop data");

  return [CPKeyedArchiver archivedDataWithRootObject:["foo"]];
}

- (CPArray)collectionView:(CPCollectionView)aCollectionView dragTypesForItemsAtIndexes:(CPIndexSet)indices
{
  return [ProcedureDragType];
}

@end
