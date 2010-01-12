@import <Critter4Us/util/Step.j>
@import <Critter4Us/util/StateMachineCoordinator.j>
@import <Critter4Us/test/testutil/ScenarioTestCase.j>


@implementation FirstStep : Step
{
  int counter;
}

- (void) setUpNotifications
{
  [self notificationNamed: "count"
                    calls: @selector(count:)];

  [self notificationNamed: "finish"
                    calls: @selector(finish:)];
}

- (void) start
{
  counter = 0;
}

- (void) count: aNotification
{
  counter++;
}

- (void) finish: aNotification
{
  [self resignInFavorOf: NextStep]; 
}

@end

@implementation NextStep : Step
@end


@implementation StepTest : ScenarioTestCase
{
  CPString variableToBeSet;
}

- (void) setUp
{
  sut = [FirstStep alloc];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
}

- (void) test_life_span
{
  [scenario sutWillBeGiven: ['master']]
  [sut initWithMaster: sut.master];
  [sut start];
  [self assert: 0 equals: sut.counter];

  [self sendNotification: "count"];
  [self assert: 1 equals: sut.counter];

  [scenario 
    during: function() { 
      [self sendNotification: "finish"];
    }
  behold: function() { 
      [sut.master shouldReceive: @selector(takeStep:)
                           with: NextStep];
    }
  andSo: function() { 
      [self sendNotification: "count"];
      [self assert: 1 equals: sut.counter]; // Notifications turned off.
    }];
}

- (void) test_alternate_way_of_resigning__it_documents_a_quirk
{
  // You need to start the next step before performing any action
  // that might provoke new notifications, else the new notifications
  // might get dropped.

  [sut initWithMaster: self]; // Act like master; see below
  [sut start];

  variableToBeSet = "unset";
  [sut afterResigningInFavorOf: NextStep 
            causeNextEventWith: function() {
      variableToBeSet = "set";
    }];
  [self assert: "set" equals: variableToBeSet];
}

// When the next step is called for, the variable should still be
// unset. It should be set after this method returns. Note: can't put
// assert into a behold! clause because that function is executed at
// the end of the method, well after nextStep: returns.
-(void) takeStep: step
{
  [self assert: "unset" equals: variableToBeSet];
}

@end


