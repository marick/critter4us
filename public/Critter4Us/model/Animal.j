@import <Foundation/Foundation.j>

@implementation Animal : CPObject
{
  CPString name;
  CPString kind;
}

- (id) initWithName: aName kind: aKind
{
  name = aName;
  kind = aKind;
  return self;
}

- (CPBoolean) isEqual: other
{
  if (! [name isEqual: other.name]) return NO;
  if (! [kind isEqual: other.kind]) return NO;
  return YES;
}

- (id) hash
{
  hashval = (([name hash] << 5) ^ [kind hash]) & 0xFFFFFF;
  return hashval;
}



@end
