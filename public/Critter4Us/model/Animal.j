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
}

@end
