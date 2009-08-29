@import <Critter4Us/controller/SecondStageController.j>
@import "ScenarioTestCase.j"

@implementation SecondStageControllerTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[SecondStageController alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardCollaborators: ['containingView']];
  [scenario sutHasDownwardCollaborators: ['persistentStore']];
}


-(void)testCanHideViews
 {
  [scenario
   given: function() {
      [sut.containingView setHidden: YES];
    }
  sequence: function() {
      [sut hideViews];
    }
  means: function() {
      [self assertTrue: [sut.containingView hidden]];
    }];
}


-(void)testCanShowViews
 {
  [scenario
   given: function() {
      [sut.containingView setHidden: NO];
    }
  sequence: function() {
      [sut showViews];
    }
  means: function() {
      [self assertFalse: [sut.containingView hidden]];
    }];
}


@end	
