@import <Critter4Us/page-for-making-reservations/state-machine/StepPMR.j>
@import "StateMachineTestCase.j"


@implementation FirstStep : StepPMR
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

@implementation StepPMRTest : StateMachineTestCase
{
}

- (void) setUp
{
  sut = [FirstStep alloc];
  [super setUp];
}

- (void) test_life_span
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
                           with: NextStep];
    }];

  [self sendNotification: "count"];
  [self assert: 1 equals: sut.counter]; // Notifications turned off.
    }];
}

- (void) test_alternate_way_of_resigning__it_documents_a_quirk
{
  // You need to start the next step before performing any action
  // that might provoke new notifications, else the new notifications
  // might get dropped.

  [sut start];
  [sut.master = self];

  NextStep['started'] = NO;
  [sut afterResigningInFavorOf: NextStep 
            causeNextEventWith: function() {
      [self assert: YES equals: NextStep["started"]];
          }];
}

-(void) nextStep: step // Behave like the master (normally a CoordinatorPMR).
{
  step['started'] = YES;
}

@end

@implementation NextStep : StepPMR 
{
}
@end

