@import <Critter4Us/model/NamedObject.j>

@implementation NamedObjectTest : OJTestCase
{
  Procedure base;
  Procedure equal;
  Procedure diffName;
}

- (void) setUp
{
  base = [[NamedObject alloc] initWithName: "base"];
  equal = [[NamedObject alloc] initWithName: "base"];
  diffName = [[NamedObject alloc] initWithName: "not base"];
}

- (void) testEquality
{
  [self assertTrue: [base isEqual: base]];
  [self assertTrue: [base isEqual: equal]];
  [self assertFalse: [base isEqual: diffName]];
}

- (void) testHash
{
  [self assertTrue: [[base hash] isEqual: [equal hash]]];
}

- (void) testComparison
{
  [self assert: CPOrderedSame equals: [base compareNames: equal]];
  [self assert: CPOrderedAscending equals: [base compareNames: diffName]];
  [self assert: CPOrderedDescending equals: [diffName compareNames: base]];
}

- (void) testComparisonIsCaseInsensitive
{
  var one = [[NamedObject alloc] initWithName: 'a'];
  var two = [[NamedObject alloc] initWithName: 'A'];

  [self assert: CPOrderedSame equals: [one compareNames: two]];
}


@end
