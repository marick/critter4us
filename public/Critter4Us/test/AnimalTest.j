@import <Critter4Us/model/Animal.j>

@implementation AnimalTest : OJTestCase
{
  Animal base;
  Animal equal;
  Animal diffName;
  Animal diffKind;
}

- (void) setUp
{
  base = [[Animal alloc] initWithName: "base" kind: 'base kind'];
  equal = [[Animal alloc] initWithName: "base" kind: 'base kind'];
  diffName = [[Animal alloc] initWithName: "not base" kind: 'base kind'];
  diffKind = [[Animal alloc] initWithName: "base" kind: 'not base kind'];
}

- (void) testEquality
{
  [self assertTrue: [base isEqual: base]];
  [self assertTrue: [base isEqual: equal]];
  [self assertFalse: [base isEqual: diffName]];
  [self assertFalse: [base isEqual: diffKind]];
}

- (void) testHash
{
  [self assertTrue: [[base hash] isEqual: [equal hash]]];
}



@end
