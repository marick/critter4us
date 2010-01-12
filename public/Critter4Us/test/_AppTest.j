@import <Critter4Us/App.j>
@import <Critter4Us/test/testutil/ScenarioTestCase.j>

@implementation _AppTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[App alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasDownwardOutlets: ['pvrPageController', 'pmrPageController',
                                    'pdaPageController']];

  [sut initializationIndependentOfUI];
  [[CPApplication sharedApplication] setDelegate: sut];
}

-(void) test_that_app_can_foreground_one_page
{
  [scenario 
    during: function() {
      [sut foreground: sut.pvrPageController];
    }
  behold: function() { 
      [sut.pvrPageController shouldReceive: @selector(appear)];
      [sut.pmrPageController shouldReceive: @selector(disappear)];
      [sut.pdaPageController shouldReceive: @selector(disappear)];
    }];
}


-(void) test_that_clicking_the_HTML_edit_button_starts_editing
{
  [scenario 
   during: function() { 
      AppForwarder.edit(33);
    }
  behold: function() {
      [self listenersWillReceiveNotification: ModifyReservationNews
                                  containingObject: 33];
      [sut.pvrPageController shouldReceive: @selector(disappear)];
      [sut.pmrPageController shouldReceive: @selector(appear)];
    }];
}

-(void) test_that_clicking_the_HTML_copy_button_starts_copying
{
  [scenario 
   during: function() { 
      AppForwarder.copy(33);
    }
  behold: function() {
      [self listenersWillReceiveNotification: CopyReservationNews
                                  containingObject: 33];
      [sut.pvrPageController shouldReceive: @selector(disappear)];
      [sut.pmrPageController shouldReceive: @selector(appear)];
    }];
}

@end
