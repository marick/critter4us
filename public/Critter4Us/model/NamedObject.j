@import <Foundation/Foundation.j>

@implementation NamedObject : CPObject
{
  CPString name;
}

- (id) initWithName: aName
{
  self = [super init];
  [self setName: aName];
  return self;
}

- (CPString) name
{
  return name;
}

- (void) setName: aName
{
  name = aName;
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
