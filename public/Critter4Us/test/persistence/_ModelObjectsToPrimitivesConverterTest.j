@import <Critter4Us/util/Time.j>
@import <Critter4Us/test/testutil/TestUtil.j>
@import <Critter4Us/util/Timeslice.j>
@import <Critter4Us/model/Animal.j>
@import <Critter4Us/model/Procedure.j>
@import <Critter4Us/model/Group.j>
@import <Critter4Us/persistence/ModelObjectsToPrimitivesConverter.j>

@implementation _ModelObjectsToPrimitivesConverterTest : OJTestCase
{
}



-(void) testTurnsNamedObjectsIntoNames
{
  var capp = [[NamedObject alloc] initWithName: 'proc'];
  [self assert: "proc" equals: [ModelObjectsToPrimitivesConverter convert: capp]];
}

-(void) testTurnsStringsIntoStrings
{
  var capp = "proc"
  [self assert: "proc" equals: [ModelObjectsToPrimitivesConverter convert: capp]];
}

-(void) testTurnsTimesIntoStrings
{
  [self assert: "morning"
        equals: [ModelObjectsToPrimitivesConverter convert: [Time morning]]];
  [self assert: "afternoon"
        equals: [ModelObjectsToPrimitivesConverter convert: [Time afternoon]]];
  [self assert: "evening"
        equals: [ModelObjectsToPrimitivesConverter convert: [Time evening]]];
}

- (void) test_turns_timeslices_into_dictionaries
{
  var timeslice = [Timeslice firstDate: "99-12-10" 
			      lastDate: "99-12-12"
				  times: [[Time morning]]];
  var expected = {'firstDate':'99-12-10', 'lastDate':'99-12-12','times': ['morning']};
  var actual = [ModelObjectsToPrimitivesConverter convert: timeslice];
  [self assertTrue: [cpdict(expected) isEqualToDictionary: cpdict(actual)]];
}

- (void) test_turns_animal_descriptions_into_dictionaries
{
  var description = [[AnimalDescription alloc] initWithName: "betsy"
						    species: "bovine"
						       note: "cow"];
  var expectedElement = {'name':'betsy', 'species':'bovine', 'note':'cow'};
  var actualArray = [ModelObjectsToPrimitivesConverter convert: [description]];
  
  [self assert: 1 equals: [actualArray count]];
  [self assertTrue: [cpdict(expectedElement)
		      isEqualToDictionary: cpdict(actualArray[0])]];
}

-(void) testConvertsEmptyArrayIntoEmptyArray
{
  var capp = [ ];
  [self assert: [] equals: [ModelObjectsToPrimitivesConverter convert: []]];
}

-(void) testConvertsArraysRecursively
{
  var capp = [ [[NamedObject alloc] initWithName: "1"], "2", [Time morning] ];
  [self assert: ["1", "2", "morning"] equals: [ModelObjectsToPrimitivesConverter convert: capp]];
}

-(void) testConvertsGroupIntoHash
{
  var betsy = [[Animal alloc] initWithName: 'betsy' kind: 'cow'];
  var floating = [[Procedure alloc] initWithName: 'floating'];
  var accupuncture = [[Procedure alloc] initWithName: 'accupuncture'];

  var capp = [[Group alloc] initWithProcedures: [floating, accupuncture] animals: [betsy]];
  var expected = {'animals':['betsy'], 'procedures':['floating', 'accupuncture']};
  var actual = [ModelObjectsToPrimitivesConverter convert: capp];
  [self assert: expected['animals'] equals: actual['animals']];
  [self assert: expected['procedures'] equals: actual['procedures']];
}

-(void) testConvertsDictionaryIntoHash
{
  var capp = [CPDictionary dictionary];
  [capp setValue: [Time morning] forKey: 'time'];

  var actual = [ModelObjectsToPrimitivesConverter convert: capp];
  [self assert: 'morning' equals: actual['time']];
}


- (void) test_independent_date_conversion_routine_is_a_no_op
{
  var converter = [[ModelObjectsToPrimitivesConverter alloc] init];
  [self assert: '2009-12-01' equals: [converter convert: '2009-12-01']];
}

- (void) test_independent_date_conversion_routine_converts_times_into_names
{
  var converter = [[ModelObjectsToPrimitivesConverter alloc] init];
  [self assert: "morning" equals: [converter convert: [Time morning]]];
  [self assert: "afternoon" equals: [converter convert: [Time afternoon]]];
}



@end
