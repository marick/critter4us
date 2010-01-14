@import <Critter4Us/util/Time.j>
@import <Critter4Us/model/Animal.j>
@import <Critter4Us/model/Procedure.j>
@import <Critter4Us/model/Group.j>
@import <Critter4Us/persistence/PersistentStore.j>
@import <Critter4Us/test/testutil/ScenarioTestCase.j>
@import <Critter4Us/test/testutil/TestUtil.j>

CorrectData = function(data) { 
  return data['a json'] == "string" 
}

@implementation _PersistentStoreTest : ScenarioTestCase
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
  [scenario sutCreates: [ 'toNetworkConverter', 'fromNetworkConverter', 'uriMaker', 
                          'futureMaker']];

  [scenario sutCreates: [ 'httpMaker' ]];
  [scenario sutCreates: [ 'future' ]]
  self.future = sut.future

  timeInvariants = '{"floating":["never this animal"]}';

  betsy = [[Animal alloc] initWithName: 'betsy' kind: 'cow'];
  josie = [[Animal alloc] initWithName: 'josie' kind: 'horse'];

  floating = [[Procedure alloc] initWithName: 'floating'];
  accupuncture = [[Procedure alloc] initWithName: 'accupuncture'];


  A_json_to_model_converter = function(arg) {
    return JsonToModelConverter === [arg class];
  }


}


- (void)test_how_persistent_stores_coordinates_when_retrieving_data
{
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
      

      [sut.fromNetworkConverter shouldReceive: @selector(convert:)
                                         with: CorrectData
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
      [sut.fromNetworkConverter shouldReceive: @selector(convert:)
                                         with: CorrectData
                                    andReturn: 'a big dictionary'];
      [self listenersShouldReceiveNotification: ReservationRetrievedNews
                              containingObject: 'a big dictionary'];
    }];
}


- (void) test_persistent_store_asks_for_animals_in_service_on_date
{
  [scenario 
   during: function() { 
      [sut fetchAnimalsInServiceOnDate: '2009-12-12'];
    }
  behold: function() {
      [sut.httpMaker shouldReceive: @selector(animalsThatCanBeTakenOutOfServiceRoute:)
                              with: ['2009-12-12']
                         andReturn: "some route"];
      [sut.futureMaker shouldReceive: @selector(futureToAccomplish:convertingResultsWith:)
                                with: [AnimalsThatCanBeRemovedFromServiceRetrieved,
                                       A_json_to_model_converter]
                           andReturn: future];
      [future shouldReceive: @selector(get:from:)
                       with: ["some route", sut.network]];
    }];
}



- (void) test_how_persistentStore_coordinates_taking_animals_out_of_service
{
  var animals = [ [[NamedObject alloc] initWithName: 'fred'] ];
  var date = '2001-12-01';

  [scenario 
   during: function() { 
      [sut takeAnimals: ["some animals"] outOfServiceOn: "some date"];
    }
  behold: function() {
      [sut.uriMaker shouldReceive: @selector(POSTAnimalsOutOfServiceURI)
                        andReturn: 'uri'];
      [sut.toNetworkConverter shouldReceive: @selector(convert:)
                                       with: "some date"
                                  andReturn: "a converted date"];
      [sut.toNetworkConverter shouldReceive: @selector(convert:)
                                       with: [["some animals"]]
                                  andReturn: ["some converted animals"]];
      [sut.uriMaker shouldReceive: @selector(POSTContentFrom:)
                             with: function(arg) { 
                                        [self assert: "a converted date" equals: arg['date']];
                                        [self assert: ["some converted animals"] equals: arg['animals']];
                                        return YES;
                                   }
                        andReturn: 'data=content'];
      [sut.futureMaker shouldReceive: @selector(spawnPostTo:withRoute:content:notificationName:)
                                with: [sut.network, 'uri', "data=content", 
                                          UniversallyIgnoredNews]];
    }];
}

// Note: some PersistentStore methods that do nothing but trampoline
// over to Future are not tested, since they're no more complex than
// setters.


@end
