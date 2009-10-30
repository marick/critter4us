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
  
  id timeInvariants;
}



- (void)setUp
{
  sut = [[PersistentStore alloc] init];
  [sut awakeFromCib];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasDownwardCollaborators: ['network', 'toNetworkConverter', 'fromNetworkConverter', 'uriMaker']];
  timeInvariants = '{"floating":["never this animal"]}';
  [sut setTimeInvariantExclusions: timeInvariants];

  betsy = [[Animal alloc] initWithName: 'betsy' kind: 'cow'];
  josie = [[Animal alloc] initWithName: 'josie' kind: 'horse'];

  floating = [[Procedure alloc] initWithName: 'floating'];
  accupuncture = [[Procedure alloc] initWithName: 'accupuncture'];
}

- (void)test_how_persistent_store_coordinates_when_retrieving_data
{
  // TODO: replace complicated convert:withAddedExclusions: functions
  // with a simple checker function.
  [scenario 
   during: function() { 
      [sut loadInfoRelevantToDate: 'a date' time: 'a time'];
    }
  behold: function() {
      [sut.toNetworkConverter shouldReceive: @selector(convertDate:)
                                       with: 'a date'
                                  andReturn: 'a network date'];
      [sut.toNetworkConverter shouldReceive: @selector(convertTime:)
                                       with: 'a time'
                                  andReturn: 'a network time'];
      [sut.uriMaker shouldReceive: @selector(reservationURIWithDate:time:)
                             with: ['a network date', 'a network time']
                        andReturn: 'uri'];
      [sut.network shouldReceive: @selector(GETJsonFromURL:)
                            with: 'uri'
                       andReturn: '{"a json":"string"}'];
      

      var hasCorrectData = function(data) { 
        return data['a json'] == "string" }
      var hasExtraExclusions = function(exclusions) {
        return exclusions['floating'] == 'never this animal' }
      [sut.fromNetworkConverter shouldReceive: @selector(convert:withAddedExclusions:)
                                         with: [hasCorrectData, hasExtraExclusions]
                                    andReturn: 'a big dictionary'];
      [self listenersShouldReceiveNotification: AnimalAndProcedureNews
                              containingObject: 'a big dictionary'];
    }];
}



-(void)test_how_persistent_store_coordinates_when_posting_a_reservation
{
  [scenario 
   during: function() {
      [sut makeReservation: 'reservation data'];
    }
  behold: function() {
      
      [sut.toNetworkConverter shouldReceive: @selector(convert:)
                                       with: 'reservation data'
                                  andReturn: {'a':'jshash'}];
      [sut.uriMaker shouldReceive: @selector(POSTReservationURI)
                        andReturn: 'uri'];
      [sut.uriMaker shouldReceive: @selector(POSTReservationContentFrom:)
                             with: function(arg) { return arg['a'] == 'jshash'}
                        andReturn: 'content'];
      [sut.network shouldReceive: @selector(POSTFormDataTo:withContent:)
                            with: ['uri', 'content']
                       andReturn: '{"reservation":"1"}'];
      [self listenersShouldReceiveNotification: ReservationStoredNews
                              containingObject: '1'];
    }
   ];
}

- (void) xtestUpdatingOfReservation
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

-(void)xtestCanFetchTableInfoFromNetwork
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

-(void) xtestCanFetchReservationDataFromNetworkForEditing
{
  var aReservation = { 'instructor':'dr dawn',
                       'course' : 'vcm3',
                       'date' : '2009-09-02',
                       'morning' : true,
                       'groups' : []
  };
  [scenario 
   during: function() {
      return [sut editReservation: 1];
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


-(void) xtestCanHandleAfternoonAsWellAsMorning
{
  var aReservation = { 'morning' : false };

  [scenario 
   during: function() {
      return [sut editReservation: 1];
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

-(void) xtestReservationDataIncludesGroupProcedureAndAnimalObjects
{
  var aReservation = { 'groups' : [ {'procedures' : ['accupuncture', 'floating'],
                                     'animals' : ['betsy', 'josie'] },
                                    {'procedures' : ['accupuncture'],
                                     'animals' : ['josie']} ],
                       'kindMap' : { 'betsy' : 'cow', 'josie' : 'horse' }
                     };

  [scenario 
   during: function() {
      return [sut editReservation: 1];
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
  [self fail];
}

@end
