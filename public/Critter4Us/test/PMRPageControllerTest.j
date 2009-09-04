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

-(void) testFloatingWindowsCanBeHiddenEvenWhenPageIsUnhidden
{
  [sut.target.failOnUnexpectedSelector = YES];
  [sut.animalDragList.failOnUnexpectedSelector = YES];
  [sut.procedureDragList.failOnUnexpectedSelector = YES];

  [scenario
    previousAction: function() {
      [sut.pageView setHidden:YES];
      [sut setDisplayFloatingWindowsOnPageReveal: NO];
    }
   during: function() {
      [sut appear];
    }
  behold: function() {
      // Nothing
    }
  andSo: function() {
     [self assertFalse: [sut.pageView hidden]];
   }];
}

-(void) testFloatingWindowsCanBeShownWhenPageisUnhidden
{
  [scenario 
    previousAction: function() {
      [sut.pageView setHidden:YES];
      [sut setDisplayFloatingWindowsOnPageReveal: YES];
    }
   during: function() {
      [sut appear];
    }
  behold: function() {
      [sut.target shouldReceive:@selector(orderFront:)];
      [sut.animalDragList shouldReceive:@selector(orderFront:)];
      [sut.procedureDragList shouldReceive:@selector(orderFront:)];
    }
  andSo: function() {
     [self assertFalse: [sut.pageView hidden]];
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

-(void) testCanHideFloatingWindowsWithoutAffectingFutureBehavior
{
  [scenario
   previousAction: function() { 
     [sut.pageView setHidden:NO];
     [sut setDisplayFloatingWindowsOnPageReveal: YES];
   }
   during: function() {
     [sut hideFloatingWindows];
   }
  behold: function() {
      [sut.target shouldReceive:@selector(orderOut:)];
      [sut.animalDragList shouldReceive:@selector(orderOut:)];
      [sut.procedureDragList shouldReceive:@selector(orderOut:)];
    }
   andSo: function() {
      [self assertFalse: [sut.pageView hidden]]; // Still.
      [self assertTrue: sut.displayFloatingWindowsOnPageReveal]; // Still
   }];
}

-(void) testCanShowFloatingWindowsWithoutAffectingFutureBehavior
{
  [scenario
   previousAction: function() { 
     [sut setDisplayFloatingWindowsOnPageReveal: NO];
   }
   during: function() {
     [sut showFloatingWindows];
   }
  behold: function() {
      [sut.target shouldReceive:@selector(orderFront:)];
      [sut.animalDragList shouldReceive:@selector(orderFront:)];
      [sut.procedureDragList shouldReceive:@selector(orderFront:)];
    }
   andSo: function() {
      [self assertFalse: sut.displayFloatingWindowsOnPageReveal]; // Still
   }];
}

@end
