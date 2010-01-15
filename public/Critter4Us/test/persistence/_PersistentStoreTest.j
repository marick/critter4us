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
  [scenario sutCreates: [ 'toNetworkConverter', 'primitivesConverter', 'httpMaker', 
					      'futureMaker', 'continuationMaker']];

  [scenario sutCreates: [ 'future' ]]
  self.future = sut.future

  timeInvariants = '{"floating":["never this animal"]}';

  betsy = [[Animal alloc] initWithName: 'betsy' kind: 'cow'];
  josie = [[Animal alloc] initWithName: 'josie' kind: 'horse'];

  floating = [[Procedure alloc] initWithName: 'floating'];
  accupuncture = [[Procedure alloc] initWithName: 'accupuncture'];


  object_of_class = function(expected) {
    return function(actual) {
      return expected === [actual class];
    }
  }

  primitive_dictionary = function(expected) { 
    return function(actual) {
      // TODO: Should check in both directions? Are we checking equality or that
      // what's expected is there?
      for (var key in expected) 
      {
        [self assert: expected[key] equals: actual[key]];
      }
      return YES;
    }
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
      [sut.httpMaker shouldReceive: @selector(reservationRouteWithDate:time:)
                             with: ['a network date', 'a network time']
                        andReturn: 'route'];
      [sut.network shouldReceive: @selector(GETJsonFromURL:)
                            with: 'route'
                       andReturn: '{"a json":"string"}'];
      

      [sut.primitivesConverter shouldReceive: @selector(convert:)
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
      [sut.httpMaker shouldReceive: @selector(POSTReservationRoute)
                        andReturn: 'route'];
      [sut.httpMaker shouldReceive: @selector(POSTContentFrom:)
                             with: function(arg) { return arg['a'] == 'jshash'}
                        andReturn: 'content'];
      [sut.network shouldReceive: @selector(POSTFormDataTo:withContent:)
                            with: ['route', 'content']
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
      [sut.httpMaker shouldReceive: @selector(fetchReservationRoute:)
                             with: ['id']
                        andReturn: 'route'];
      [sut.network shouldReceive: @selector(GETJsonFromURL:)
                            with: 'route'
                       andReturn: '{"a json":"string"}'];
      [sut.primitivesConverter shouldReceive: @selector(convert:)
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
      [sut.httpMaker shouldReceive: @selector(route_animalsThatCanBeTakenOutOfService_data:)
                              with: ['2009-12-12']
                         andReturn: "some route"];
      [sut.continuationMaker shouldReceive: @selector(continuationNotifying:afterConvertingWith:)
                                with: [AnimalsThatCanBeRemovedFromServiceRetrieved,
                                       object_of_class(JsonToModelObjectsConverter)]
                           andReturn: "a continuation"];
      [sut.network shouldReceive: @selector(get:continuingWith:)
			    with: ["some route", "a continuation"]];
    }];
}



- (void) test_how_persistentStore_coordinates_taking_animals_out_of_service
{
  [scenario 
   during: function() { 
      [sut takeAnimals: ["some animals"] outOfServiceOn: "some date"];
    }
  behold: function() {
      [sut.httpMaker shouldReceive: @selector(POSTAnimalsOutOfServiceRoute)
                        andReturn: 'route'];
      [sut.toNetworkConverter shouldReceive: @selector(convert:)
                                       with: "some date"
                                  andReturn: "a converted date"];
      [sut.toNetworkConverter shouldReceive: @selector(convert:)
                                       with: [["some animals"]]
                                  andReturn: ["some converted animals"]];
      [sut.httpMaker shouldReceive: @selector(POSTContentFrom:)
                              with: primitive_dictionary({'date' : 'a converted date',
                                                          'animals' : ["some converted animals" ] })
                         andReturn: "data=content"];

      [sut.futureMaker shouldReceive: @selector(futureToAccomplish:)
                                with: UniversallyIgnoredNews
                           andReturn: future];
      [sut.future shouldReceive: @selector(postContent:toRoute:on:)
                           with: ["data=content", 'route', sut.network]];
    }];
}



- (void) test_fetching_the_HTML_table_of_animals_with_pending_reservations_coordination
{
  [scenario 
   during: function() { 
      [sut fetchAnimalsWithPendingReservationsOnDate: "some date"];
    }
  behold: function() {
      [sut.httpMaker shouldReceive: @selector(pendingReservationAnimalListWithDate:)
			      with: "some date"
			 andReturn: 'route'];
      [sut.continuationMaker shouldReceive: @selector(continuationNotifying:)
                                with: TableOfAnimalsWithPendingReservationsNews
                           andReturn: "continuation"];
      [sut.network shouldReceive: @selector(get:continuingWith:)
                           with: ["route", 'continuation']];
    }];
}

- (void) test_fetching_the_HTML_table_of_all_reservations_coordination
{
  [scenario 
   during: function() { 
      [sut allReservationsHtml];
    }
  behold: function() {
      [sut.httpMaker shouldReceive: @selector(route_getAllReservations_html)
			 andReturn: 'route'];
      [sut.continuationMaker shouldReceive: @selector(continuationNotifying:)
                                with: AllReservationsHtmlNews
                           andReturn: "continuation"];
      [sut.network shouldReceive: @selector(get:continuingWith:)
                           with: ["route", 'continuation']];
    }];
}

@end
