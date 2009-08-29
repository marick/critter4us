@import <Foundation/Foundation.j>

@implementation Time : CPObject
{
  CPString string;
}

+ (id) morning
{
  return [[self alloc] initWithString: "morning"];
}

+ (id) afternoon
{
  return [[self alloc] initWithString: "afternoon"];
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
