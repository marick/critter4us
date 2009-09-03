@import <Critter4Us/make-reservations/PMRPageController.j>
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
  [scenario sutHasSidewaysCollaborators: ['groupingsController']];
}

-(void) testAppearingUnhidesPage
{
  [scenario
   previousAction: function() { 
     [sut.pageView setHidden:NO];
   }
   during: function() {
     [sut appear];
   }
  behold: function() {
      [sut.groupingsController shouldReceive:@selector(isInputDesired)
                                   andReturn:NO]; // see below for meaning
      
    }
  andSo: function() {
     [self assertFalse: [sut.pageView hidden]];
   }];
}

-(void) testAppearingLeavesGroupingControlsInvisibleIfDesired
{
  [sut.target.failOnUnexpectedSelector = YES];
  [sut.animalDragList.failOnUnexpectedSelector = YES];
  [sut.procedureDragList.failOnUnexpectedSelector = YES];

  [scenario
   during: function() {
      [sut appear];
    }
  behold: function() {
      [sut.groupingsController shouldReceive:@selector(isInputDesired)
                                   andReturn:NO];
      // but nothing else.
    }];
}

-(void) testAppearingCanAlsoShowGroupingControls
{
  [scenario 
   during: function() {
      [sut appear];
    }
  behold: function() {
      [sut.groupingsController shouldReceive:@selector(isInputDesired)
                                   andReturn:YES];
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
