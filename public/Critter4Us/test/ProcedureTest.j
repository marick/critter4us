@import <Critter4Us/model/Procedure.j>

@implementation ProcedureTest : OJTestCase
{
  Procedure base;
  Procedure equal;
  Procedure diffName;
}

- (void) setUp
{
  base = [[Procedure alloc] initWithName: "base"];
  equal = [[Procedure alloc] initWithName: "base"];
  diffName = [[Procedure alloc] initWithName: "not base"];
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

@end
