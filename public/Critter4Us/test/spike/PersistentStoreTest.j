@import <Critter4Us/util/Time.j>
@import <Critter4Us/persistence/PersistentStore.j>
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

- (void)testPersistentStoreMakesNetworkInfoAvailable
{
  [scenario 
   during: function() { 
      [sut focusOnDate: '2009-02-02' time: [Time morning]];
    }
  behold: function() {
      uri = jsonURI(CourseSessionDataBlobRoute+"?date=2009-02-02&time=morning");
      [sut.network shouldReceive: @selector(GETJsonFromURL:)
                            with: uri
                       andReturn: '{"animals":["betsy","josie"],"kindMap":{"betsy":"cow","josie":"horse"},"procedures":["proc1"],"exclusions":{"proc1":["betsy"]}}'];
    }
  andSo: function() {
      [self assert: ["betsy", "josie"] equals: sut.allAnimalNames];
      [self assert: "cow" equals: sut.kindMap['betsy']];
      [self assert: "horse" equals: sut.kindMap['josie']];
      [self assert: ["proc1"] equals: sut.allProcedureNames];
      [self assert: ['betsy'] equals: [sut.exclusions valueForKey: 'proc1']];
    }]
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

-(void)testCanFetchTableInfoFromNetwork
{
  [scenario
    during: function() { 
      return [sut pendingReservationTableAsHtml];
    }
  behold: function() {
      [sut.network shouldReceive: @selector(GETHtmlfromURL:) 
                            with: AllReservationsTableRoute
                       andReturn: "<html>stuff</html>"];
    }
  andSo: function() { 
      [self assert: "<html>stuff</html>" equals: scenario.result];
    }];
}

// Test utility methods

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
