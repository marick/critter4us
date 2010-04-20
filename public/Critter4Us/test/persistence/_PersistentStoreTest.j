@import <Critter4Us/util/Time.j>
@import <Critter4Us/model/Animal.j>
@import <Critter4Us/model/Procedure.j>
@import <Critter4Us/model/Group.j>
@import <Critter4Us/persistence/PersistentStore.j>
@import <Critter4Us/test/testutil/ScenarioTestCase.j>
@import <Critter4Us/test/testutil/TestUtil.j>

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
  [scenario sutCreates: [ 'primitivizer', 'httpMaker', 
			  'futureMaker', 'continuationMaker']];

  [scenario sutCreates: [ 'future' ]]
  self.future = sut.future

  timeInvariants = '{"floating":["never this animal"]}';

  betsy = [[Animal alloc] initWithName: 'betsy' kind: 'cow'];
  josie = [[Animal alloc] initWithName: 'josie' kind: 'horse'];

  floating = [[Procedure alloc] initWithName: 'floating'];
  accupuncture = [[Procedure alloc] initWithName: 'accupuncture'];


}


- (void)test_how_persistent_stores_coordinates_desire_to_load_timeslice_blob
{
  [scenario 
   during: function() { 
      [sut loadInfoRelevantToTimeslice: "a timeslice"];
    }
  behold: function() {
      [sut.primitivizer shouldReceive: @selector(convert:)
				 with: 'a timeslice'
			    andReturn: 'a primitive version of a timeslice'];
      [sut.httpMaker shouldReceive: @selector(animalsAndProceduresAvailableAtTimeslice:)
                             with: 'a primitive version of a timeslice'
                        andReturn: 'route'];


      [sut.continuationMaker shouldReceive: @selector(continuationNotifying:afterConvertingWith:)
				      with: [AnimalAndProcedureNews,
    				             Some(JsonToModelObjectsConverter)]
				 andReturn: "a continuation"];
      [sut.network shouldReceive: @selector(get:continuingWith:)
			    with: ['route', 'a continuation']];
    }];
}

-(void)test_how_persistent_store_coordinates_when_posting_a_reservation
{
  [scenario 
   during: function() {
      [sut makeReservation: 'reservation data'];
    }
  behold: function() {
      [sut.httpMaker shouldReceive: @selector(POSTReservationRoute)
                        andReturn: 'route'];

      [sut.primitivizer shouldReceive: @selector(convert:)
				 with: 'reservation data'
			    andReturn: {'a':'jshash'}];

      [sut.httpMaker shouldReceive: @selector(reservationPOSTContentFrom:)
			      with: Containing_at_least({'a':'jshash'})
			 andReturn: 'content'];


      [sut.continuationMaker shouldReceive: @selector(continuationNotifying:afterConvertingWith:)
				      with: [ReservationStoredNews,
  					     Some(JsonToModelObjectsConverter)]
				 andReturn: "a continuation"];
      [sut.network shouldReceive: @selector(postContent:toRoute:continuingWith:)
			with: ["content", "route", "a continuation"]];
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
      [sut.continuationMaker shouldReceive: @selector(continuationNotifying:afterConvertingWith:)
				      with: [ReservationRetrievedNews,
					      Some(JsonToModelObjectsConverter)]
				 andReturn: "a continuation"];
      [sut.network shouldReceive: @selector(get:continuingWith:)
			    with: ['route', 'a continuation']]
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
					Some(JsonToModelObjectsConverter)]
                           andReturn: "a continuation"];
      [sut.network shouldReceive: @selector(get:continuingWith:)
			    with: ["some route", "a continuation"]];
    }];
}

- (void) test_how_persistentStore_coordinates_adding_animals
{
  [scenario 
   during: function() { 
      [sut addAnimals: ["some animal descriptions"]];
    }
  behold: function() {
      [sut.httpMaker shouldReceive: @selector(POSTAddAnimalsRoute)
                        andReturn: 'route'];

      [sut.primitivizer shouldReceive: @selector(convert:)
				 with: [["some animal descriptions"]]
			    andReturn: ["array of hashes"]];
      [sut.httpMaker shouldReceive: @selector(genericPOSTContentFrom:)
                              with: [["array of hashes"]]
                         andReturn: "data=content"];

      [sut.continuationMaker shouldReceive: @selector(continuationNotifying:afterConvertingWith:)
				      with: [UniversallyIgnoredNews,
  				             Some(JsonToModelObjectsConverter)]
				 andReturn: "a continuation"];
      [sut.network shouldReceive: @selector(postContent:toRoute:continuingWith:)
			with: ["data=content", "route", "a continuation"]];
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

      [sut.primitivizer shouldReceive: @selector(convert:)
				 with: "some date"
			    andReturn: "a converted date"];
      [sut.primitivizer shouldReceive: @selector(convert:)
				 with: [["some animals"]]
			    andReturn: ["some converted animals"]];
      [sut.httpMaker shouldReceive: @selector(genericPOSTContentFrom:)
                              with: Containing_at_least(
					      {'date' : 'a converted date',
  					       'animals' : ["some converted animals" ] })
                         andReturn: "data=content"];

      [sut.continuationMaker shouldReceive: @selector(continuationNotifying:)
				    with: UniversallyIgnoredNews
				 andReturn: "a continuation"];
      [sut.network shouldReceive: @selector(postContent:toRoute:continuingWith:)
			with: ["data=content", "route", "a continuation"]];
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
