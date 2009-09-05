@import <AppKit/AppKit.j>
@import "../util/Constants.j"

@implementation DropTarget : CPView
{
  id controller;
  SEL dropAction;
  CPColor subtleHint;
  CPColor strongHint;
  CPDragType dragType;
}

- (void) giveSubtleHint
{
  [self setBackgroundColor: subtleHint];
}

- (void) giveStrongHint
{
  [self setBackgroundColor: strongHint];
}

- (CPBoolean) prepareForDragOperation: (id) aSender
{
  return YES;
}

- (CPBoolean)performDragOperation:(CPDraggingInfo)aSender
{
  // TODO: do we really need to encode this?
  var value = [CPKeyedUnarchiver unarchiveObjectWithData:[[aSender draggingPasteboard] dataForType:dragType]];
  [controller performSelector: dropAction withObject: value];
  return YES;
}

- (CPDragOperation)draggingEntered:(CPDraggingInfo)aSender
{
  [self giveStrongHint];
  // TODO: return value CPDragOperationCopy should have. Don't know why
  // definition is inaccessible. In current Cappuccino, value is ignored
  // anyway.
  return 1<<1;
}

- (void)draggingExited:(CPDraggingInfo)aSender
{
  [self giveSubtleHint];
}

- (void) concludeDragOperation: (id) aSender
{
  [self giveSubtleHint];
}

- (CPString) droppedString
{
  // TODO
}

@end
