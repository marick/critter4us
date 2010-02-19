@import <Foundation/Foundation.j>
@import "Time.j"


@implementation Timeslice : CPObject
{
  CPString firstDate;
  CPString lastDate;
  CPSet times;
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
  times = [CPSet setWithArray: anArray];
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
         [times isEqualToSet: other.times];
}

- (String) description 
{
  return "<Timeslice: " + firstDate + " to " + lastDate + "/" + [times description] + ">";
}

@end
