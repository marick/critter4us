@import <Critter4Us/util/Time.j>
@import <Critter4Us/model/Animal.j>
@import <Critter4Us/model/Procedure.j>
@import <Critter4Us/model/Group.j>
@import <Critter4Us/persistence/PersistentStore.j>
@import "ScenarioTestCase.j"
@import "TestUtil.j"

HasCorrectData = function(data) { 
  return data['a json'] == "string" 
}
HasExtraExclusions = function(exclusions) {
  return exclusions['floating'] == 'never this animal' 
}
GetEditableReservationRoute = @"reservation"; // DELETEME



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
      

      [sut.fromNetworkConverter shouldReceive: @selector(convert:withAddedExclusions:)
                                         with: [HasCorrectData, HasExtraExclusions]
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

- (void) test_how_persistentStore_coordinates_fetching_a_reservation
{
  [scenario 
   during: function() { 
      [sut fetchReservation: 'id'];
    }
  behold: function() {
      [sut.uriMaker shouldReceive: @selector(fetchReservationURI:)
                             with: ['id']
                        andReturn: 'uri'];
      [sut.network shouldReceive: @selector(GETJsonFromURL:)
                            with: 'uri'
                       andReturn: '{"a json":"string"}'];
      [sut.fromNetworkConverter shouldReceive: @selector(convert:withAddedExclusions:)
                                         with: [HasCorrectData, HasExtraExclusions]
                                    andReturn: 'a big dictionary'];
      [self listenersShouldReceiveNotification: ReservationRetrievedNews
                              containingObject: 'a big dictionary'];
    }];
}


-(void)test_can_fetch_reservation_list_data_from_network
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

@end
