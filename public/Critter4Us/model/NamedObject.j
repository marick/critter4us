@import <Foundation/Foundation.j>

@implementation NamedObject : CPObject
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

- (id) compareNames: other
{
  return [self.name caseInsensitiveCompare: other.name];
}

- (CPString) summary
{
  return name;
}

- (CPString) description
{
  return [super description] + " " + name;
}

@end
