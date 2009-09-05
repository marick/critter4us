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

// TODO: Does it make sense to follow target/action protocol? 
- (CPBoolean)performDragOperation:(CPDraggingInfo)aSender
{
  // TODO: do we really need to encode this?
  var data = [[aSender draggingPasteboard] dataForType:dragType];
  var droppedString = [CPKeyedUnarchiver unarchiveObjectWithData:data];
  
  [NotificationCenter postNotificationName: OneAnimalChosenNews
                                    object: droppedString];
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
  return droppedString;
}

- (void) setContent
{
  alert("drop target content set");
  // TODO
}


- (void) stopObserving
{
  // Required by ScenarioTestCase.up
}


@end
