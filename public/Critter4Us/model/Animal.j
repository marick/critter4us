@import <Foundation/Foundation.j>
@import "NamedObject.j"

@implementation Animal : NamedObject
{
  CPString kind;
}

- (id) initWithName: aName kind: aKind
{
  self = [super initWithName: aName];
  kind = aKind;
  return self;
}

- (CPString) kind
{
  return kind;
}

- (CPBoolean) isEqual: other
{
  if (! [super isEqual: other]) return NO;
  if (! [kind isEqual: other.kind]) return NO;
  return YES;
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
