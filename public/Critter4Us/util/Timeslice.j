@import <Foundation/Foundation.j>
@import "Time.j"


@implementation Timeslice : CPObject
{
  CPString firstDate;
  CPString lastDate;
  CPArray times;
}

+ (id) firstDate: firstString lastDate: lastString times: anArray
{
  return [[self alloc] initWithFirstDate: firstString 
				lastDate: lastString
				   times: anArray];
}

+ (id) degenerateDate: aString time: aTime
{
  return [[self alloc] initWithFirstDate: aString 
				lastDate: aString
				     times: [aTime]];
}


- (id) initWithFirstDate: firstString lastDate: lastString times: anArray
{
  self = [super init];
  firstDate = firstString;
  lastDate = lastString;
  times = anArray;
  return self;
}

 
- (CPInteger) hash
{
  return [[firstDate, lastDate, times] hash];
}

- (BOOL) isEqual: other
{ 
  return [firstDate isEqual: other.firstDate] &&    
         [lastDate isEqual: other.lastDate] &&    
         [[CPSet setWithArray: times] isEqualToSet: [CPSet setWithArray: other.times]];
}

- (CPArray) sortedTimes
{
  var retval = [];
  if ([times containsObject: [Time morning]])
    [retval addObject: [Time morning]];
  if ([times containsObject: [Time afternoon]])
    [retval addObject: [Time afternoon]];
  if ([times containsObject: [Time evening]])
    [retval addObject: [Time evening]];
  return retval;
}

- (String) description 
{
  return "{{Timeslice: " + firstDate + " to " + lastDate + "/" + [[self sortedTimes] description] + "}}";
}

+ (String) today
{
  var date = new Date();
  return [CPString stringWithFormat: "%d-%02d-%02d",
		   date.getFullYear(), date.getMonth()+1, date.getDate()];

}

@end
