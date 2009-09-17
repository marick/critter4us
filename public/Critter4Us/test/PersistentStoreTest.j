@import <Critter4Us/util/Time.j>
@import <Critter4Us/model/Animal.j>
@import <Critter4Us/model/Procedure.j>
@import <Critter4Us/model/Group.j>
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
  var betsy = [[Animal alloc] initWithName: 'betsy' kind: 'cow'];
  var josie = [[Animal alloc] initWithName: 'josie' kind: 'horse'];

  var expectedAnimals = [betsy, josie];
  var expectedProcedures = [CPArray arrayWithObject:
                                 [[Procedure alloc] initWithName: 'proc1'
                                                       excluding: [betsy]]];
  [scenario 
   during: function() { 
      [sut loadInfoRelevantToDate: '2009-02-02' time: [Time morning]];
    }
  behold: function() {
      uri = jsonURI(CourseSessionDataBlobRoute+"?date=2009-02-02&time=morning");
      [sut.network shouldReceive: @selector(GETJsonFromURL:)
                            with: uri
                       andReturn: '{"animals":["betsy","josie"],"kindMap":{"betsy":"cow","josie":"horse"},"procedures":["proc1"],"exclusions":{"proc1":["betsy"]}}'];

      [self listenersWillReceiveNotification: InitialDataForACourseSessionNews
                                checkingWith: function(notification) {
          var dict = [notification object];
          var actualAnimals = [dict valueForKey: 'animals'];
          var actualProcedures = [dict valueForKey: 'procedures'];
          if (! [actualAnimals isEqual: expectedAnimals]) return NO;
          if (! [actualProcedures isEqual: expectedProcedures]) return NO;
          return YES;
        }];
    }
  andSo: function() {
      [self assert: ["betsy", "josie"] equals: sut.allAnimalNames]; // TODO delete old accessors
      [self assert: "cow" equals: sut.kindMap['betsy']];
      [self assert: "horse" equals: sut.kindMap['josie']];
      [self assert: ["proc1"] equals: sut.allProcedureNames];

      [self assert: expectedAnimals equals: [sut animals]]; // TODO these can go as well.
      [self assert: expectedProcedures equals: [sut procedures]];
      [self assert: ['betsy'] equals: [sut.exclusions valueForKey: 'proc1']];
    }]
}


-(void)testPostingOfReservation
{
  var time = [Time afternoon];
  var betsy = [[Animal alloc] initWithName: 'betsy' kind: 'cow'];
  var floating = [[Procedure alloc] initWithName: 'floating'];
  var accupuncture = [[Procedure alloc] initWithName: 'accupuncture'];

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


@end
