@import <Critter4Us/model/Procedure.j>
@import <Critter4Us/model/Animal.j>

@implementation ProcedureTest : OJTestCase
{
}

- (void) setUp
{
}


- (void) testDefaultProcedureHasNoExclusions
{
  var proc = [[Procedure alloc] initWithName: "proc"];
  [self assert: [] equals: [proc animalsThisProcedureExcludes]];
}

- (void) testCanCreateWithExclusions
{
  var toExclude = [[Animal alloc] initWithName: 'betsy' kind: 'cow'];
  var proc = [[Procedure alloc] initWithName: "proc" excluding: [toExclude]];
  [self assert: [toExclude] equals: [proc animalsThisProcedureExcludes]];
}

- (void) testEqualityAlsoChecksExclusions
{
  var oneAnimal = [[Animal alloc] initWithName: 'one' kind: 'b'];
  var another = [[Animal alloc] initWithName: 'another' kind: 'b'];

  var oneWithExclusions = [[Procedure alloc] initWithName: 'base'
                                            excluding: [oneAnimal]];
  var equalNotIdentical = [[Procedure alloc] initWithName: 'base'
                                            excluding: [oneAnimal]];
  var different = [[Procedure alloc] initWithName: 'base' excluding: [another]];

  [self assertFalse: [oneWithExclusions isEqual: different]];
  [self assertTrue: [oneWithExclusions isEqual: equalNotIdentical]];
}

@end
