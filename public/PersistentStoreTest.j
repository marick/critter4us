@import "PersistentStore.j"
@import "ScenarioTestCase.j"

@implementation PersistentStoreTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[PersistentStore alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
 [scenario sutHasDownwardCollaborators: ['network']];
}


- (void)testFetchesAnimalNamesIntoArray
{
  [scenario
   during: function() {
      return [sut allAnimalInfo];
   }
  behold: function() {
      [sut.network shouldReceive: @selector(GETJsonFromURL:)
       with: jsonURI(AllAnimalsRoute)
           andReturn: '{"animals":[["betsy"],{"betsy":"cow"}]}']
    }]
  [self assert: ['betsy'] equals: scenario.result[0]];
  [self assert: 'cow' equals: scenario.result[1]['betsy']];
}

- (void)testFetchesProcedureNamesIntoArray
{
  [scenario
   during: function() {
      return [sut allProcedureNames];
   }
  behold: function() {
      [sut.network shouldReceive: @selector(GETJsonFromURL:)
       with: jsonURI(AllProceduresRoute)
       andReturn: '{"procedures":["1", "2"]}'];
    }]
    [self assert: ['1', '2'] equals: scenario.result];
}

- (void)testFetchesJsonExclusions
{
  [scenario
   during: function() {
      return [sut exclusionsForDate:"2009-02-23" time: [Time morning]];
    }
  behold: function() {
      [sut.network shouldReceive: @selector(GETJsonFromURL:)
       with: jsonURI(ExclusionsRoute) + "?date=2009-02-23&time=morning"
       andReturn: '{"exclusions":{"veniculture":["one"],"aquaculture":["2","3"]}}'];
    }
   ];
    
  var expected = [CPDictionary dictionaryWithJSObject: {"veniculture":["one"],"aquaculture":["2","3"]}];
  [self assertTrue: [expected isEqualToDictionary: scenario.result]];
}

-(void)testPostingOfReservation
{
  [scenario 
   during: function() {
      var time = [Time afternoon];
      var data = [CPDictionary dictionaryWithObjects:
		  ['2009-03-23', time, "morin", "vm333",
		   ["betsy"], ["rhinoscopy (cows)"]]
		  forKeys: ['date', 'time', 'instructor', 'course',
		  'animals', 'procedures']];
      return [sut makeReservation: data];
    }
  behold: function() { 
      [sut.network shouldReceive: @selector(POSTFormDataTo:withContent:)
       with: [jsonURI(StoreReservationRoute), 
	      function(content) {
		  [self assertTrue: content.match("animals%22%3A")];
		  // Can't get the regex to escape a paren.
		  r = /rhinoscopy%20.cows./;
		  [self assertTrue: content.match(r)];
		  [self assertTrue: content.match(/date.*2009/)];
		  return YES;
	      }]
       andReturn: '{"reservation":"1"}'];
    }
   ];
  [self assert: '1' equals: scenario.result];
}

-(void) testDictionaryToJSStringifiesObjects
{
  var dict = [CPDictionary dictionary];
  [dict setValue: "string" forKey: "string"];
  [dict setValue: 1 forKey:"number"];
  [dict setValue: [Time afternoon] forKey: "time"];
  [dict setValue: ["animal", "also"] forKey: "animals"];
  
  var js = [sut dictionaryToJS: dict];
  [self assert: "string" equals: js['string']];
  [self assert: "1" equals: js['number']];
  [self assert: "afternoon" equals: js['time']];
  [self assert: ["animal", "also"] equals: js['animals']];
}

@end
