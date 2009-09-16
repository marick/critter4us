@import <Critter4Us/model/Animal.j>
@import <Critter4Us/model/Procedure.j>
@import <Critter4Us/model/Group.j>

@implementation GroupTest : OJTestCase
{
}

- (void) testNamesAreFormedFromProcedures
{
  var floating = [[Procedure alloc] initWithName: 'floating'];
  var accupuncture = [[Procedure alloc] initWithName: 'accupuncture'];
  var venipuncture = [[Procedure alloc] initWithName: 'venipuncture'];

  var betsy = [[Animal alloc] initWithName: 'betsy' kind: 'cow'];
  
  var group = [[Group alloc] initWithProcedures: [floating, accupuncture, venipuncture]
                                        animals: [betsy]];

  [self assert: "floating, accupuncture, venipuncture"
        equals: [group name]];
}

- (void) testGroupsAreIndependent // old bug in Capp 0.7.1
{
  var betsy = [[Animal alloc] initWithName: 'betsy' kind: 'cow'];
  var floating = [[Procedure alloc] initWithName: 'floating'];
  var accupuncture = [[Procedure alloc] initWithName: 'accupuncture'];

  var group1 = [[Group alloc] initWithProcedures: [floating]
                                         animals: [betsy]];

  [self assert: "floating" equals: [[[group1 procedures] objectAtIndex: 0] name]];
  var group2 = [[Group alloc] initWithProcedures: [accupuncture]
                                         animals: [betsy]];
  [self assert: "floating" equals: [[[group1 procedures] objectAtIndex: 0] name]];
}

@end
