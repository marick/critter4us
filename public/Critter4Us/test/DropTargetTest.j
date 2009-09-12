@import <Critter4Us/view/DropTarget.j>
@import "ScenarioTestCase.j"

@implementation DropTargetTest : ScenarioTestCase
{
  CPColor normalColor;
  CPColor hoverColor;
}

- (void)setUp
{
  sut = [[DropTarget alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasDownwardCollaborators: ['controller']];
  normalColor = [CPColor greenColor];
  hoverColor = [CPColor redColor];
}

- (void)testColorHintsAreGivenAppropriately
{
  [scenario 
    testAction: function() {
      [sut setNormalColor: normalColor andHoverColor: hoverColor];
    }
  andSo: function() {
      [self assert: normalColor equals: [sut backgroundColor]];
      [sut draggingEntered: UnusedArgument];
      [self assert: hoverColor equals: [sut backgroundColor]];
      [sut draggingExited: UnusedArgument];
      [self assert: normalColor equals: [sut backgroundColor]];
  
      [sut draggingEntered: UnusedArgument];
      [self assert: hoverColor equals: [sut backgroundColor]];
      [sut performDragOperation: UnusedArgument];
      [self assert: hoverColor equals: [sut backgroundColor]];
      [sut concludeDragOperation: UnusedArgument];
      [self assert: normalColor equals: [sut backgroundColor]];
    }];
}

- (void)testDropTargetAsksControllerForAdviceAboutDropping
{
  [scenario 
    previousAction: function() {
      [sut acceptDragType: AnimalDragType];
    }
  during: function() {
      return [sut prepareForDragOperation: [self dropInfoContaining: 'arbitrary data']];
    }
  behold: function() {
      [sut.controller shouldReceive: @selector(canBeDropped:)
                               with: 'arbitrary data'
                          andReturn: YES];
    }
  andSo: function() {
      [self assert: YES equals: scenario.result];
    }];
}

- (void)testDropTargetTellsControllerWhatWasDroppedAndWhere
{
  [scenario 
    previousAction: function() {
      [sut acceptDragType: AnimalDragType];
    }
  during: function() {
      return [sut performDragOperation: [self dropInfoContaining: 'arbitrary data']];
    }
  behold: function() {
      [sut.controller shouldReceive: @selector(receiveNewItem:forCollectionView:)
                               with: ['arbitrary data', sut.collectionView]
                          andReturn: YES];
    }
  andSo: function() {
      [self assert: YES equals: scenario.result];
    }];
}

- (CPDraggingInfo) dropInfoContaining: (id) data
{
  var pasteboard = [[Mock alloc] initWithName: "dragging pasteboard"];
  [pasteboard shouldReceive: @selector(dataForType:)
                  andReturn: data];
  var fakeDragInfo = [[Mock alloc] initWithName: "dragging source"];
  [fakeDragInfo shouldReceive: @selector(draggingPasteboard)
                      andReturn: pasteboard];
  return fakeDragInfo;
}



@end
