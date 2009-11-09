@import <Foundation/Foundation.j>

Morning='morning';
Afternoon='afternoon';
Evening='evening';

@implementation Time : CPObject
{
  CPString string;
}

+ (id) morning
{
  return [[self alloc] initWithString: Morning];
}

+ (id) afternoon
{
  return [[self alloc] initWithString: Afternoon];
}

+ (id) evening
{
  return [[self alloc] initWithString: Evening];
}

- (id) initWithString: aString
{
  self = [super init];
  string = aString;
  return self;
}
 
- (CPString) description
{
  return string;
} 

- (CPInteger) hash
{
  return [string hash];
}

- (BOOL) isEqual: other
{
  return [other.string isEqual: string];
}


@end
