@import <Critter4Us/App.j>
@import "ScenarioTestCase.j"

@implementation AppTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[App alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasDownwardCollaborators: ['allReservationPageController, pmrPageController']];

  [[CPApplication sharedApplication] setDelegate: sut];
  
}

-(void) testThatClickingAnHtmlEditButtonStartsEditing
{
  [scenario 
   during: function() { 
      AppForwarder.edit(33);
    }
  behold: function() {
      [self listenersWillReceiveNotification: ModifyReservationNews
                                  containingObject: 33];
      [sut.allReservationPageController shouldReceive: @selector(disappear)];
      [sut.pmrPageController shouldReceive: @selector(appear)];
    }];
}

@end
