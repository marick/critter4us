@import <Critter4Us/view/TimeControl.j>
@import <Critter4Us/test/testutil/ScenarioTestCase.j>

@implementation _TimeControlTest : ScenarioTestCase
{
  TimeControl sut;
}

- (void) setUp
{
  sut = [[TimeControl alloc] initAtX: 0 y: 0];
}


- (void) test_can_read_buttons_and_produce_time
{
  [sut.morningButton setState: CPOnState];
  [self assert: [[Time morning]] equals: [sut times]];

  [sut.afternoonButton setState: CPOnState];
  [self assert: [[Time morning], [Time afternoon]] equals: [sut times]];

  [sut.eveningButton setState: CPOnState];
  [self assert: [[Time morning], [Time afternoon], [Time evening]] equals: [sut times]];
}

- (void) test_can_set_time_to_set_buttons
{
  [sut setTimes: [CPArray arrayWithObject: [Time afternoon]]];
  [self assert: CPOffState equals: [sut.morningButton state]];
  [self assert: CPOnState equals: [sut.afternoonButton state]];
  [self assert: CPOffState equals: [sut.eveningButton state]];

  [sut setTimes: [CPSet setWithObject: [Time evening]]];
  [self assert: CPOffState equals: [sut.morningButton state]];
  [self assert: CPOffState equals: [sut.afternoonButton state]];
  [self assert: CPOnState equals: [sut.eveningButton state]];

  [sut setTimes: [ [Time morning], [Time evening], [Time afternoon] ] ];
  [self assert: CPOnState equals: [sut.morningButton state]];
  [self assert: CPOnState equals: [sut.afternoonButton state]];
  [self assert: CPOnState equals: [sut.eveningButton state]];
}

@end
