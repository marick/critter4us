@import "../util/Time.j"

@implementation TimeTest : OJTestCase
{
}

- (void) testEquality
{
  [self assertFalse: [[Time morning] isEqual: [Time afternoon]]];
  [self assertTrue: [[Time morning] isEqual: [Time morning]]];
  [self assertFalse: [[Time morning] isEqual: "morning"]];
}

- (void) testDescription
{
  [self assert: "morning" equals: [[Time morning] description]];
  [self assert: "afternoon" equals: [[Time afternoon] description]];
}

@end
