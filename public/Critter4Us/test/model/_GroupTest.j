@import <Critter4Us/model/Animal.j>
@import <Critter4Us/model/Procedure.j>
@import <Critter4Us/model/Group.j>

@implementation _GroupTest : OJTestCase
{
  Procedure floating;
  Procedure accupuncture;
  Procedure venipuncture;
  Animal betsy;
  Animal jake;
  Animal hoss;
}

- (void) setUp
{
  floating = [[Procedure alloc] initWithName: 'floating'];
  accupuncture = [[Procedure alloc] initWithName: 'accupuncture'];
  venipuncture = [[Procedure alloc] initWithName: 'venipuncture'];
  betsy = [[Animal alloc] initWithName: 'betsy' kind: 'cow'];
  jake = [[Animal alloc] initWithName: 'jake' kind: 'horse'];
  hoss = [[Animal alloc] initWithName: 'hoss' kind: 'horse'];
}

- (void) testGroupsCanBeEmpty
{
  var group = [[Group alloc] initWithProcedures: [] animals: []];
  [self assertTrue: [group isEmpty]];
}

- (void) testAGroupIsEmptyIfEitherProcedureOrAnimalListsAreEmpty
{
  [self assertTrue: [[[Group alloc] initWithProcedures: [floating] animals: []] isEmpty]];
  [self assertTrue: [[[Group alloc] initWithProcedures: [] animals: [betsy]] isEmpty]];

  [self assertFalse: [[[Group alloc] initWithProcedures: [floating] animals: [betsy]] isEmpty]];
}

- (void) testGroupsCanReturnListofProcedureNames
{
  var group = [[Group alloc] initWithProcedures: [floating, accupuncture, venipuncture]
                                        animals: [betsy]];

  [self assert: ["floating", "accupuncture", "venipuncture"]
        equals: [group procedureNames]];
}


- (void) testGroupsCanReturnListofAnimalNames
{
  var group = [[Group alloc] initWithProcedures: [floating, accupuncture, venipuncture]
                                        animals: [betsy]];

  [self assert: ["betsy"]
        equals: [group animalNames]];
}


- (void) testNamesAreFormedFromProcedures
{
  var group = [[Group alloc] initWithProcedures: [floating, accupuncture, venipuncture]
                                        animals: [betsy]];

  [self assert: "floating, accupuncture, venipuncture"
        equals: [group name]];
}

- (void) testNoProceduresMeansEmptyName
{
  var group = [[Group alloc] initWithProcedures: []
                                        animals: [betsy]];

  [self assert: ""
        equals: [group name]];
}

- (void) testEquality
{
  var original = [[Group alloc] initWithProcedures: [floating] animals: [betsy]];
  var same = [[Group alloc] initWithProcedures: [floating] animals: [betsy]];
  var animals = [[Group alloc] initWithProcedures: [floating] animals: []];
  var procedures = [[Group alloc] initWithProcedures: [] animals: [betsy]];

  [self assertTrue: [original isEqual: same]];
  [self assertFalse: [original isEqual: procedures]];
  [self assertFalse: [original isEqual: animals]];
}
    

- (void) testHash
{
  var original = [[Group alloc] initWithProcedures: [floating] animals: [betsy]];
  var same = [[Group alloc] initWithProcedures: [floating] animals: [betsy]];

  [self assert: [original hash] equals: [same hash]];
}
    

- (void) testHashForEmpties // because of peculiar hash implementation.
{
  var original = [[Group alloc] initWithProcedures: [CPArray array] animals: [CPArray array]];
  var same = [[Group alloc] initWithProcedures: [CPArray array] animals: [CPArray array]];

  [self assert: [original hash] equals: [same hash]];
}
    

- (void) testGroupsAreIndependent // old bug in Capp 0.7.1
{
  var group1 = [[Group alloc] initWithProcedures: [floating]
                                         animals: [betsy]];

  [self assert: "floating" equals: [[[group1 procedures] objectAtIndex: 0] name]];
  var group2 = [[Group alloc] initWithProcedures: [accupuncture]
                                         animals: [betsy]];
  [self assert: "floating" equals: [[[group1 procedures] objectAtIndex: 0] name]];
}

- (void) testGroupsCanCheckWhetherExcludedAnimalsHaveBeenPutInsideThem
{
  hoss = [hoss copy]; // we want exclusion to be by isEqual, not identity. 
  betsy = [betsy copy];
  var procedureExcludingAnimal = [[Procedure alloc] initWithName: 'excluder' excluding: [betsy, jake]];
  var brokenGroup = [[Group alloc] initWithProcedures: [procedureExcludingAnimal]
                                              animals: [betsy, hoss]];
  var okGroup = [[Group alloc] initWithProcedures: [procedureExcludingAnimal]
                                          animals: [hoss]];

  [self assertFalse: [okGroup containsExcludedAnimals]];
  [self assertTrue: [brokenGroup containsExcludedAnimals]];
  [self assert: [betsy] equals: [brokenGroup animalsIncorrectlyPresent]];
}

-(void) testGroupsCanAcceptSameNamedProceduresThatExcludeDifferentAnimals
{
  var group = [[Group alloc] initWithProcedures: [floating, accupuncture]
                                        animals: []];
  var newFloating = [[Procedure alloc] initWithName: 'floating' excluding: [betsy]];
  var newAccupuncture = [[Procedure alloc] initWithName: 'accupuncture' excluding: [betsy]];
  var newVenipuncture = [[Procedure alloc] initWithName: 'venipuncture' excluding: [betsy]];

  // Interesting: it appears that == and === are isEqual: rather than 
  // object identity tests.

  [self assertFalse: [floating UID] === [newFloating UID]];
  [self assertFalse: [accupuncture UID] === [newAccupuncture UID]];
  [self assertFalse: [venipuncture UID] === [newVenipuncture UID]];

  [group exclusionsHaveChangedForThese: [newFloating, newVenipuncture, newAccupuncture]];

  var newProcedures = [group procedures];
  [self assert: 2 equals: [newProcedures count]];
    
  [self assert: [newFloating UID] equals: [newProcedures[0] UID]];
  [self assert: [newAccupuncture UID] equals:[newProcedures[1] UID]];
}


-(void) testGroupsWillRejectNewlyExcludedAnimals
{
  var group = [[Group alloc] initWithProcedures: [floating, accupuncture]
                                        animals: [betsy, jake, hoss]];
  var newFloating = [[Procedure alloc] initWithName: 'floating' excluding: [betsy]];
  var newAccupuncture = [[Procedure alloc] initWithName: 'accupuncture'];
  var newVenipuncture = [[Procedure alloc] initWithName: 'venipuncture' excluding: [hoss]];
  // Note that exclusion of Hoss will have no effect. Venipuncture was not one of the
  // original procedures, so it does not appear in the updated procedures and has 
  // no effect to exclude Hoss.

  [group exclusionsHaveChangedForThese: [newFloating, newVenipuncture, newAccupuncture]];
  [self assert: [jake, hoss] equals: [group animals]];
  [self assert: [betsy] equals: [group animalsFreshlyExcluded]];
}


@end
