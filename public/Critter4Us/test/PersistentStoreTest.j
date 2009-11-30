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



@implementation PersistentStoreTest : ScenarioTestCase
{
  Animal betsy;
  Animal josie;
  Procedure floating;
  Procedure accupuncture;
  
  id timeInvariants;
}

- (void) test_there_is_a_singleton_for_persistent_store
{
  var first = [PersistentStore sharedPersistentStore];
  var second = [PersistentStore sharedPersistentStore];
  [self assert: first equals: second];
}

- (void)setUp
{
  sut = [[PersistentStore alloc] init];
  [sut awakeFromCib];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasDownwardOutlets: ['network']];
  [scenario sutCreates: [ 'toNetworkConverter', 'fromNetworkConverter', 'uriMaker']];

  timeInvariants = '{"floating":["never this animal"]}';
  [sut setTimeInvariantExclusions: timeInvariants];

  betsy = [[Animal alloc] initWithName: 'betsy' kind: 'cow'];
  josie = [[Animal alloc] initWithName: 'josie' kind: 'horse'];

  floating = [[Procedure alloc] initWithName: 'floating'];
  accupuncture = [[Procedure alloc] initWithName: 'accupuncture'];
}


- (void)test_how_persistent_stores_coordinates_when_retrieving_data
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
      [sut.uriMaker shouldReceive: @selector(POSTContentFrom:)
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

- (void) test_persistent_store_uses_uri_maker_to_construct_uri
{
  [scenario 
   during: function() { 
      [sut fetchAnimalsInServiceOnDate: '2009-12-12'];
    }
  behold: function() {
      [sut.uriMaker shouldReceive: @selector(inServiceAnimalListWithDate:)
                             with: ['2009-12-12']];
    }];
}



- (void) test_how_persistentStore_coordinates_taking_animals_out_of_service
{
  var animals = [ [[NamedObject alloc] initWithName: 'fred'] ];
  var date = '2001-12-01';
  // TODO: Mock framework can't handle same method call w/ different arguments, 
  // so use the real thing instead of documenting interaction as commented out below.
  [sut.toNetworkConverter = [[ToNetworkConverter alloc] init]];

  [scenario 
   during: function() { 
      [sut takeAnimals: animals outOfServiceOn: date];
    }
  behold: function() {
      [sut.uriMaker shouldReceive: @selector(POSTAnimalsOutOfServiceURI)
                        andReturn: 'uri'];
      //      [sut.toNetworkConverter shouldReceive: @selector(convert:)
      //                                       with: date
      //                                  andReturn: date];
      //      [sut.toNetworkConverter shouldReceive: @selector(convert:)
      //                                       with: animals
      //                                  andReturn: ['fred']];
      [sut.uriMaker shouldReceive: @selector(POSTContentFrom:)
                             with: function(arg) { 
          [self assert: date equals: arg['date']];
          [self assert: ['fred'] equals: arg['animals']];
          return YES;
        }
                        andReturn: 'data=content'];
      // Not tested: forwarding to Future. 
    }];
}


// Note: some PersistentStore methods that do nothing but trampoline
// over to Future are not tested, since they're no more complex than
// setters.


@end
