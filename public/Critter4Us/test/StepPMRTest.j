@import <Critter4Us/page-for-making-reservations/state-machine/StepPMR.j>
@import "StateMachineTestCase.j"


@implementation SubClass : StepPMR
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
  [self resignInFavorOf: SubClass]; // or any other Step class.
}

@end

@implementation StepPMRTest : StateMachineTestCase
{
}

- (void) setUp
{
  sut = [SubClass alloc];
  [super setUp];
}

- (void) testLifespan
{
  [sut start];
  [self sendNotification: "count"];
  [self assert: 1 equals: sut.counter];

  [scenario
    during: function() {
      [self sendNotification: "finish"];
    }
  behold: function() {
      [sut.master shouldReceive: @selector(nextStep:)
                           with: SubClass];
    }];

  [self sendNotification: "count"];
  [self assert: 1 equals: sut.counter]; // Notifications turned off.
    }];
  
  
}


@end
