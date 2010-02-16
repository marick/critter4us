@import <Foundation/Foundation.j>
@import "Time.j"


@implementation Timeslice : CPObject
{
  String thinDate;
  Time thinTime;
}

- (id) initWithThinDate: aString thinTime: aTime
{
  self = [super init];
  thinDate = aString;
  thinTime = aTime;
  return self;
}
 
- (CPInteger) hash
{
  return [[thinDate, thinTime] hash];
}

- (BOOL) isEqual: other
{ 
  return [thinDate isEqual: other.thinDate] &&    
         [thinTime isEqual: other.thinTime];
}

- (String) description 
{
  return "<" + [self class] + " " + thinDate + "/" + thinTime + ">";
}

@end
