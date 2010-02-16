@import <Critter4Us/util/Timeslice.j>

@implementation _TimesliceTest : OJTestCase
{
}

- (void) testEquality
{
  var reference = [[Timeslice alloc] initWithThinDate: "date"
                                             thinTime: [Time morning]];
  var equal = [[Timeslice alloc] initWithThinDate: "date" 
                                         thinTime: [Time morning]];
  var badDate = [[Timeslice alloc] initWithThinDate: "date2" 
                                           thinTime: [Time morning]];
  var badTime = [[Timeslice alloc] initWithThinDate: "date2" 
                                           thinTime: [Time afternoon]];

  [self assert: reference equals: equal];
  [self assertFalse: [reference isEqual: badDate]];
  [self assertFalse: [reference isEqual: badTime]];
}


@end
