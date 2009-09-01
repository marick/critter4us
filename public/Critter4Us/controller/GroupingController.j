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
  dragTargetView = [window contentView];
  return self;
}

-(void) awakeFromCib
{
  [dragTargetView setBackgroundColor: [CPColor whiteColor]];
  [window registerForDraggedTypes: [ProcedureDragType, AnimalDragType]];
  [window setDelegate: self];
}

-(void) draggingEntered: (id) sender
{
  [dragTargetView setBackgroundColor: [CPColor redColor]];
}

-(void) draggingExited: (id) sender
{
  [dragTargetView setBackgroundColor: [CPColor whiteColor]];
}

- (void)performDragOperation:(CPDraggingInfo)aSender
{
  //    [self setActive:NO];
  alert("Dragged!");
  //    [_paneLayer setImage:[CPKeyedUnarchiver unarchiveObjectWithData:[[aSender draggingPasteboard] dataForType:PhotoDragType]]];
}


- (void) stopObserving
{
  // TODO: Make this AwakeningWindowController? Protocol?
  [[CPNotificationCenter defaultCenter] removeObserver: self];
}

@end
