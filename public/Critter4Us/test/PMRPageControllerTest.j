@import <Critter4Us/page-for-making-reservations/PMRPageController.j>
@import "ScenarioTestCase.j"

@implementation PMRPageControllerTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[PMRPageController alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];

  [scenario sutHasUpwardCollaborators:
              ['pageView', 'target', 'animalDragList', 'procedureDragList']];
}

-(void) testAppearingUnhidesPage
{
  [scenario
   previousAction: function() { 
     [sut.pageView setHidden:YES];
   }
  testAction: function() {
      [sut appear];
   }
  andSo: function() {
     [self assertFalse: [sut.pageView hidden]];
   }];
}

-(void) testAppearingLeavesGroupingWindowsInvisibleIfDesired
{
  [sut.target.failOnUnexpectedSelector = YES];
  [sut.animalDragList.failOnUnexpectedSelector = YES];
  [sut.procedureDragList.failOnUnexpectedSelector = YES];

  [scenario
    previousAction: function() {
      [sut setDisplayFloatingWindows: NO];
    }
   during: function() {
      [sut appear];
    }
  behold: function() {
      // Nothing
    }];
}

-(void) testAppearingCanAlsoShowGroupingControls
{
  [scenario 
    previousAction: function() {
      [sut setDisplayFloatingWindows:YES];
    }
   during: function() {
      [sut appear];
    }
  behold: function() {
      [sut.target shouldReceive:@selector(orderFront:)];
      [sut.animalDragList shouldReceive:@selector(orderFront:)];
      [sut.procedureDragList shouldReceive:@selector(orderFront:)];
    }];
}

-(void) testDisappearingMeansBecomingHiddenAndOrderedOut
{
  [scenario
   previousAction: function() { 
     [sut.pageView setHidden:NO];
   }
   during: function() {
     [sut disappear];
   }
  behold: function() {
      [sut.target shouldReceive:@selector(orderOut:)];
      [sut.animalDragList shouldReceive:@selector(orderOut:)];
      [sut.procedureDragList shouldReceive:@selector(orderOut:)];
    }
   andSo: function() {
     [self assertTrue: [sut.pageView hidden]];
   }];
}

@end
