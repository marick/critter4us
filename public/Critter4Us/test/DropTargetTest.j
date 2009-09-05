@import <Critter4Us/view/DropTarget.j>
@import "ScenarioTestCase.j"

@implementation DropTargetTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[DropTarget alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasDownwardCollaborators: ['controller']];
}

-(void) testDroppingThrowsNotification
{
  [scenario
   during: function() {
      [self drop: "some string"];
    }
  behold: function() { 
      [self listenersWillReceiveNotification: OneAnimalChosenNews
                            containingObject: "some string"];
    }
   ];
}

    // Util

-(void) drop: aName
{
  dataglob = [CPKeyedArchiver archivedDataWithRootObject: aName];
  pasteboard = [[Mock alloc] initWithName: "pasteboard"];
  [pasteboard shouldReceive: @selector(dataForType:)
                  andReturn: dataglob];
  fakeDragInfo = [[Mock alloc] initWithName: "drag source"];
  [fakeDragInfo shouldReceive: @selector(draggingPasteboard)
                      andReturn: pasteboard];
  [sut performDragOperation: fakeDragInfo];
}

@end
