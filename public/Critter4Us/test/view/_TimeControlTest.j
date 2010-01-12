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

- (void) test_pressing_one_button_turns_others_off
{
  [sut.morningButton setState: CPOnState];
  [sut.afternoonButton setState: CPOffState];
  [sut.eveningButton setState: CPOffState];

  [sut.afternoonButton setState: CPOnState];
  [self assert: CPOffState equals: [sut.morningButton state]];
  [self assert: CPOnState equals: [sut.afternoonButton state]];
  [self assert: CPOffState equals: [sut.eveningButton state]];

  [sut.eveningButton setState: CPOnState];
  [self assert: CPOffState equals: [sut.morningButton state]];
  [self assert: CPOffState equals: [sut.afternoonButton state]];
  [self assert: CPOnState equals: [sut.eveningButton state]];

  [sut.morningButton setState: CPOnState];
  [self assert: CPOnState equals: [sut.morningButton state]];
  [self assert: CPOffState equals: [sut.afternoonButton state]];
  [self assert: CPOffState equals: [sut.eveningButton state]];
}

- (void) test_can_read_buttons_and_produce_time
{
  [sut.morningButton setState: CPOnState];
  [self assert: [Time morning] equals: [sut time]];

  [sut.afternoonButton setState: CPOnState];
  [self assert: [Time afternoon] equals: [sut time]];

  [sut.eveningButton setState: CPOnState];
  [self assert: [Time evening] equals: [sut time]];
}

- (void) test_can_set_time_to_set_buttons
{
  [sut.morningButton setState: CPOnState];

  [sut setTime: [Time afternoon]];
  [self assert: CPOffState equals: [sut.morningButton state]];
  [self assert: CPOnState equals: [sut.afternoonButton state]];
  [self assert: CPOffState equals: [sut.eveningButton state]];

  [sut setTime: [Time evening]];
  [self assert: CPOffState equals: [sut.morningButton state]];
  [self assert: CPOffState equals: [sut.afternoonButton state]];
  [self assert: CPOnState equals: [sut.eveningButton state]];

  [sut setTime: [Time morning]];
  [self assert: CPOnState equals: [sut.morningButton state]];
  [self assert: CPOffState equals: [sut.afternoonButton state]];
  [self assert: CPOffState equals: [sut.eveningButton state]];
}

@end
