@import <AppKit/AppKit.j>
@import "../util/AwakeningObject.j"

@implementation GroupingController : CPWindowController
{
  // The use of this instance variable, rather than [self window] is a 
  // crutch to help mock-style tests.
  CPPanel window;
  CPPanel dragTargetView;
}

-(void) initWithWindow: (CPWindow) aWindow
{
  self = [super initWithWindow: aWindow];
  window = [self window];
  return self;
}

-(void) awakeFromCib
{
  [window setDelegate: self];

  // [dragTargetView setBackgroundColor: [CPColor whiteColor]];
  // [window registerForDraggedTypes: [ProcedureDragType]];
}


- (void) stopObserving
{
  // TODO: Make this AwakeningWindowController? Protocol?
  [[CPNotificationCenter defaultCenter] removeObserver: self];
}

@end
