@import <Foundation/Foundation.j>
@import "Timeslice.j"

@implementation TimesliceSummarizer : CritterObject
{
}

- (CPString) summarize: timeslice
{
  return note = [self summarizeTimes: timeslice.times
			addingSuffix: [self suffix: timeslice]] + 
                [self summarizeRangeFrom: timeslice.firstDate to: timeslice.lastDate];
}

- (CPString) summarizeTimes: rawTimes addingSuffix: suffix
{
  var times = [self order: rawTimes];
  switch ([times count]) {
  case 1: 
    return "on the " + [times[0] description] + suffix + " of ";
  case 2: 
    return "on the " + [times[0] description] + suffix + " and " + 
                       [times[1] description] + suffix + " of ";
  case 3: 
    return "for the whole day on ";
  }
}

- (CPString) summarizeRangeFrom: first to: last
{
  if ([first isEqual: last])
    return first;
  else
    return first + " through " + last;
}


- (CPString) suffix: timeslice
{
  return [timeslice.firstDate isEqual: timeslice.lastDate] ? "" : "s";
}

- (CPArray) order: array
{
  var retval = [];
  if ([array containsObject: [Time morning]])
    [retval addObject: [Time morning]];
  if ([array containsObject: [Time afternoon]])
    [retval addObject: [Time afternoon]];
  if ([array containsObject: [Time evening]])
    [retval addObject: [Time evening]];
  return retval;
}

@end
