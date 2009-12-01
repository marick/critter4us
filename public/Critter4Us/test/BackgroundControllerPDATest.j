@import <Critter4Us/page-for-deleting-animals/BackgroundControllerPDA.j>
@import "ScenarioTestCase.j"

@implementation BackgroundControllerPDATest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[BackgroundControllerPDA alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardOutlets: ['dateField', 'changeableDateView', 'fixedDateView']];
}

- (void)testNotifiesListenersWhenDateChosen
{
  [scenario
    previousAction: function() {
      [sut.dateField setStringValue: '2009-12-10'];
    }
  during: function() {
      [sut animalsInServiceForDate: UnusedArgument];
    }
  behold: function() {
      [self listenersWillReceiveNotification: UserWantsAnimalsInServiceOnDateNews
                            containingObject: '2009-12-10'];
        }];
}

- (void) testEffectiveDateIsValueOfDateField
{
  [sut.dateField setStringValue: '2009-12-10'];
  [self assert: '2009-12-10' equals: [sut effectiveDate]];
}

- (void) testCanAllowDateEntry
{
  [scenario
    during: function() {
      [sut allowDateEntry];
    }
  behold: function() {
      [sut.changeableDateView shouldReceive: @selector(setHidden:) with: NO];
      [sut.fixedDateView shouldReceive: @selector(setHidden:) with: YES];
    }];
}

- (void) testCanForbidDateEntry
{
  [scenario
    during: function() {
      [sut forbidDateEntry];
    }
  behold: function() {
      [sut.dateField shouldReceive: @selector(stringValue)
                         andReturn: "YYYY-MM-DD"];
      [sut.changeableDateView shouldReceive: @selector(setHidden:) with: YES];
      [sut.fixedDateView shouldReceive: @selector(setHidden:) with: NO];
      [sut.noteSelectedDateField shouldReceive: @selector(setStringValue:)
                                          with: function(arg) {
          [self assertFalse: [arg rangeOfString: "YYYY-MM-DD"] == nil];
          return YES;
        }];
    }];
}

- (void) test_controller_posts_notification_when_restart_button_pressed
{
  [scenario 
    during: function() {
      [sut restart: UnusedArgument];
    }
  behold: function() {
      [self listenersShouldReceiveNotification: RestartAnimalRemovalStateMachineNews];
    }];
}


@end
