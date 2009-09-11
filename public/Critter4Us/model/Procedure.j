@import <Foundation/Foundation.j>

@implementation Procedure : CPObject
{
  CPString name;
}

- (id) initWithName: aName
{
  name = aName;
  return self;
}

- (CPBoolean) isEqual: other
{
  if (! [name isEqual: other.name]) return NO;
  return YES;
}

- (id) hash
{
  hashval = [name hash];
  return hashval;
}


@end
