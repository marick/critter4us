@import <Critter4Us/util/Time.j>
@import <Critter4Us/model/Animal.j>
@import <Critter4Us/model/Procedure.j>
@import <Critter4Us/model/Group.j>
@import <Critter4Us/persistence/PersistentStore.j>
@import "ScenarioTestCase.j"
@import "TestUtil.j"

@implementation PersistentStoreTest : ScenarioTestCase
{
  Animal betsy;
  Animal josie;
  Procedure floating;
  Procedure accupuncture;
}

- (void)setUp
{
  sut = [[PersistentStore alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
 [scenario sutHasDownwardCollaborators: ['network']];

  betsy = [[Animal alloc] initWithName: 'betsy' kind: 'cow'];
  josie = [[Animal alloc] initWithName: 'josie' kind: 'horse'];

  floating = [[Procedure alloc] initWithName: 'floating'];
  accupuncture = [[Procedure alloc] initWithName: 'accupuncture'];
}

- (void)testPersistentStoreMakesNetworkInfoAvailable
{
  var expectedAnimals = [betsy, josie];
  var expectedTimeDependentProcedure = [[Procedure alloc] initWithName: 'proc1'
                                                             excluding: [betsy]];
  var expectedTimeIndependentProcedure 
  [scenario 
    previousAction: function() { 
      [sut setTimeInvariantExclusions: '{"proc1":["josie"],"proc2":["betsy"]}'];
    }
   during: function() { 
      [sut loadInfoRelevantToDate: '2009-02-02' time: [Time morning]];
    }
  behold: function() {
      uri = jsonURI(CourseSessionDataBlobRoute+"?date=2009-02-02&time=morning");
      [sut.network shouldReceive: @selector(GETJsonFromURL:)
                            with: uri
                       andReturn: '{"animals":["betsy","josie"],"kindMap":{"betsy":"cow","josie":"horse"},"procedures":["proc1", "proc2"],"exclusions":{"proc1":["betsy"]}}'];

      [self listenersWillReceiveNotification: AnimalAndProcedureNews
                                checkingWith: function(notification) {
          var dict = [notification object];
          var actualAnimals = [dict valueForKey: 'animals'];
          if (! [actualAnimals isEqual: expectedAnimals]) return NO;

          var actualProcedures = [dict valueForKey: 'procedures'];
          var proc1 = [self findProcedureNamed: 'proc1' in: actualProcedures];
          if (! [proc1 excludes: betsy]) return [self no: "proc1 allows betsy"];
          if (! [proc1 excludes: josie]) return [self no: "proc1 allows josie"];
          var proc2 = [self findProcedureNamed: 'proc2' in: actualProcedures];
          if (! [proc2 excludes: betsy]) return [self no: "proc2 allows betsy"];
          if (  [proc2 excludes: josie]) return [self no: "proc2 excludes josie"];
          return YES;
        }];
    }];
}

- (CPString) no: message
{
  CPLog(message);
  return NO;
}



-(void)testPostingOfReservation
{
  var time = [Time afternoon];

  // This test doesn't really need to use real data. The code under test doesn't
  // massage the data any more - that works been hived off to ToNetworkConverter. 
  // It can't hurt, but do something simpler if this test ever breaks.
  var group1 = [[Group alloc] initWithProcedures: [floating] animals: [betsy]];
  var group2 = [[Group alloc] initWithProcedures: [accupuncture] animals: [betsy]];

  var data = [CPDictionary
                 dictionaryWithObjects: ['2009-03-23', time, "morin", "vm333", [group1, group2]]
                               forKeys: ['date', 'time', 'instructor', 'course', 'groups']];
  [scenario 
   during: function() {
      return [sut makeReservation: data];
    }
  behold: function() {
      [sut.network shouldReceive: @selector(POSTFormDataTo:withContent:)
                            with: [jsonURI(StoreReservationRoute), 
                                          function(content) {
                                            var array = content.split(/=/);
                                            var jsonString = decodeURIComponent(array[1]);
                                            var parsed = [jsonString objectFromJSON];
                                            [self assert: '2009-03-23' equals: parsed['date']];
                                            [self assert: 'afternoon' equals: parsed['time']];
                                            [self assert: 'morin' equals: parsed['instructor']];
                                            [self assert: 'vm333' equals: parsed['course']];
                                            [self assert: 2 equals: [parsed['groups'] count]];
                                            var groupsactual = parsed['groups'];
                                            var group1actual = groupsactual[0];
                                            var group2actual = groupsactual[1];
                                            [self assert: ['betsy'] equals: group1actual['animals']];
                                            [self assert: ['floating'] equals: group1actual['procedures']];
                                            [self assert: ['betsy'] equals: group2actual['animals']];
                                            [self assert: ['accupuncture'] equals: group2actual['procedures']];
                                            
                                            return YES;
                                          }]
                       andReturn: '{"reservation":1}'];
      [self listenersWillReceiveNotification: ReservationStoredNews
                            containingObject: 1];
    }
   ];
}

- (void) testUpdatingOfReservation
{
  [scenario 
   during: function() {
      return [sut updateReservation: '33' with: cpdict({'key':'value'})];
    }
  behold: function() {
      var postContentValidator = function(content) {
        var parsed = [self decode: content];
        [self assert: '33' 
              equals: [parsed objectForKey: 'reservationID']];
        var data = [[parsed objectForKey: 'data'] objectFromJSON];
        [self assert: 'value' equals: data['key']];
        return YES;
      }
      [sut.network shouldReceive: @selector(POSTFormDataTo:withContent:)
                            with: [jsonURI(ModifyReservationRoute), postContentValidator]
                       andReturn: '{"reservation":"33"}'];
    }
  andSo: function() {
      [self assert: "33" equals: scenario.result];
    }
   ];
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

-(void) testCanFetchReservationDataFromNetworkForEditing
{
  var aReservation = { 'instructor':'dr dawn',
                       'course' : 'vcm3',
                       'date' : '2009-09-02',
                       'morning' : true,
                       'groups' : []
  };
  [scenario 
   during: function() {
      return [sut reservation: 1];
    }
  behold: function() {
      [sut.network shouldReceive: @selector(GETJsonFromURL:)
                            with: [jsonURI(GetEditableReservationRoute) + '/1']
                       andReturn: [CPString JSONFromObject: aReservation]];
    }
  andSo: function() {
      [self assert: aReservation['instructor'] 
            equals: [scenario.result valueForKey: 'instructor']];
      [self assert: aReservation['course'] 
            equals: [scenario.result valueForKey: 'course']];
      [self assert: aReservation['date'] 
            equals: [scenario.result valueForKey: 'date']];
      [self assert: [Time morning]
            equals: [scenario.result valueForKey: 'time']];
    }];
}


-(void) testCanHandleAfternoonAsWellAsMorning
{
  var aReservation = { 'morning' : false };

  [scenario 
   during: function() {
      return [sut reservation: 1];
    }
  behold: function() {
      [sut.network shouldReceive: @selector(GETJsonFromURL:)
                            with: [jsonURI(GetEditableReservationRoute) + '/1']
                       andReturn: [CPString JSONFromObject: aReservation]];
    }
  andSo: function() {
      [self assert: [Time afternoon]
            equals: [scenario.result valueForKey: 'time']];
    }];
}

-(void) testReservationDataIncludesGroupProcedureAndAnimalObjects
{
  var aReservation = { 'groups' : [ {'procedures' : ['accupuncture', 'floating'],
                                     'animals' : ['betsy', 'josie'] },
                                    {'procedures' : ['accupuncture'],
                                     'animals' : ['josie']} ],
                       'kindMap' : { 'betsy' : 'cow', 'josie' : 'horse' }
                     };

  [scenario 
   during: function() {
      return [sut reservation: 1];
    }
  behold: function() {
      [sut.network shouldReceive: @selector(GETJsonFromURL:)
                            with: [jsonURI(GetEditableReservationRoute) + '/1']
                       andReturn: [CPString JSONFromObject: aReservation]];
    }
  andSo: function() {
      var groups = [scenario.result valueForKey: 'groups'];
      [self assert: 2 equals: [groups count]];
      [self assert: [accupuncture, floating]
            equals: [[groups objectAtIndex: 0] procedures]];
      [self assert: [betsy, josie]
            equals: [[groups objectAtIndex: 0] animals]];
      [self assert: [accupuncture]
            equals: [[groups objectAtIndex: 1] procedures]];
      [self assert: [josie]
            equals: [[groups objectAtIndex: 1] animals]];
    }];
} 


// Test utility methods

- (CPString) decode: contentString
{
  var i;
  var keys = [];
  var values = [];
  
  var array = contentString.split(/[\?=\&]/);
  for(i = 0; i < array.length; i += 2)
  {
    [keys addObject: array[i]];
    [values addObject: decodeURIComponent(array[i+1])];
  }
  return [CPDictionary dictionaryWithObjects: values forKeys: keys];
}

- (Procedure) findProcedureNamed: name in: array
{
  for(i = 0; i < [array count]; i++)
  {
    var candidate = array[i];
    if ([[candidate name] isEqual: name]) 
    {
      return candidate;
    }
  }
  CPLog("No procedure found for " + name + " in " + [array description]);
  [self fail];
}

@end
