@import <AppKit/AppKit.j>
@import "../util/AwakeningObject.j"

@implementation GroupingController : AwakeningObject
{
  CPView window; 
}

-(void) awakeFromCib
{
  [window registerForDraggedTypes: [ProcedureDragType, AnimalDragType]];
}

@end
