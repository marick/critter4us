@import <Critter4Us/util/Time.j>

@implementation _TimeTest : OJTestCase
{
}

- (void) testEquality
{
  [self assertFalse: [[Time morning] isEqual: [Time afternoon]]];
  [self assertFalse: [[Time morning] isEqual: [Time evening]]];
  [self assertFalse: [[Time afternoon] isEqual: [Time evening]]];
  [self assertTrue: [[Time morning] isEqual: [Time morning]]];
  [self assertTrue: [[Time afternoon] isEqual: [Time afternoon]]];
  [self assertTrue: [[Time evening] isEqual: [Time evening]]];
  [self assertFalse: [[Time morning] isEqual: "morning"]];
}

- (void) testDescription
{
  [self assert: "morning" equals: [[Time morning] description]];
  [self assert: "afternoon" equals: [[Time afternoon] description]];
  [self assert: "evening" equals: [[Time evening] description]];
}

@end
