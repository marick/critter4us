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

- (id) compareNames: other
{
  return [self.name caseInsensitiveCompare: other.name];
}

- (id) hash
{
  hashval = (([name hash] << 5) ^ [kind hash]) & 0xFFFFFF;
  return hashval;
}

- (CPString) summary
{
  return name + ' (' + kind + ')';
}

- (CPString) description
{
  return [super description] + ' "' + [self summary] + '"';
}

@end
