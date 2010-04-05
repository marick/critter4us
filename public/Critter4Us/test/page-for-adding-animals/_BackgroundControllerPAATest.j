@import <Critter4Us/page-for-adding-animals/BackgroundControllerPAA.j>
@import <Critter4Us/test/testutil/ScenarioTestCase.j>

@implementation _BackgroundControllerPAATest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[BackgroundControllerPAA alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardOutlets: ['nameField', 'kindField', 'speciesField']];
}

- (void)test_listeners_are_notified_when_new_animal_is_added
{
  [scenario
    previously: function() {
      [sut.nameField setStringValue: 'Clara'];
      [sut.kindField setStringValue: 'cow'];
      [sut.speciesField setStringValue: 'bovine'];
    }
  during: function() {
     [sut startAddingAnimal: UnusedArgument];
    }
  behold: function() {
    
     var clara = function(actual) {
       var dict = [actual object];
       [self assert: [dict valueForKey: 'name'] equals: 'Clara'];
       [self assert: [dict valueForKey: 'kind'] equals: 'cow'];
       [self assert: [dict valueForKey: 'species'] equals: 'bovine'];
       return YES;
     }
     [self listenersWillReceiveNotification: UserWantsToAddAnAnimal 
                            checkingWith: clara];
     }];
}


@end
