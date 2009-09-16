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


@end
