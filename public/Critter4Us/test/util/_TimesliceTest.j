@import <Critter4Us/util/Timeslice.j>

@implementation _TimesliceTest : OJTestCase
{
}

- (void) test_equality_for_degenerate_case
{
  var reference = [Timeslice degenerateDate: "date" time: [Time morning]];
  var equal = [Timeslice degenerateDate: "date" time: [Time morning]];
  var badDate = [Timeslice degenerateDate: "date2" time: [Time morning]];
  var badTime = [Timeslice degenerateDate: "date2" time: [Time afternoon]];

  [self assert: reference equals: equal];
  [self assertFalse: [reference isEqual: badDate]];
  [self assertFalse: [reference isEqual: badTime]];
}

- (void) test_equality_for_other_cases
{
  var reference = [Timeslice firstDate: "first date" lastDate: "last date" 
				  times: [[Time morning]]];
  var equal = [Timeslice firstDate: "first date" lastDate: "last date" 
			     times: [[Time morning]]];
  var badFirst = [Timeslice firstDate: "bad first date" lastDate: "last date" 
				times: [[Time morning]]];
  var badLast = [Timeslice firstDate: "first date" lastDate: "bad last date" 
			       times: [[Time morning]]];
  var badTimes = [Timeslice firstDate: "first date" lastDate: "last date" 
				times: [[Time morning], [Time afternoon]]];

  [self assert: reference equals: equal];
  [self assertFalse: [reference isEqual: badFirst]];
  [self assertFalse: [reference isEqual: badLast]];
  [self assertFalse: [reference isEqual: badTimes]];
}

- (void) test_that_time_order_is_irrelevant
{
  var reference = [Timeslice firstDate: "first date" lastDate: "last date" 
				 times: [[Time morning], [Time afternoon]]];
  var equal = [Timeslice firstDate: "first date" lastDate: "last date" 
			     times: [[Time afternoon], [Time morning]]];
  [self assert: reference equals: equal];
}

@end
