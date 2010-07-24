@import <Critter4Us/persistence/HTTPMaker.j>
@import <Critter4US/test/testutil/TestUtil.j>


@implementation _HTTPMakerTest : OJTestCase
{
  HTTPmaker maker;
}

-(void) setUp
{
  maker = [[HTTPMaker alloc] init];
}

-(void) test_can_make_route_to_fetch_animal_and_procedure_info_by_timeslice
{
  var primitivizedTimeslice = {'startDate':'10-12-90', 'endDate':'10-12-90','times': ['morning']};
  [self assert: "/json/animals_and_procedures_blob?timeslice=" + [CPString JSONFromObject: primitivizedTimeslice]
        equals: [maker animalsAndProceduresAvailableAtTimeslice: primitivizedTimeslice]];
}

-(void) test_chooses_to_create_a_new_reservation_when_storing
{
  [self assert: '/json/store_reservation'
        equals: [maker POSTReservationRoute]];
}

-(void) test_can_create_content_for_posting_generic_data
{
  var data = {'aaa':'bbb'};
  [self assert: "data=%7B%22aaa%22%3A%22bbb%22%7D"
        equals: [maker genericPOSTContentFrom: data]];
}

-(void) test_can_create_content_for_posting_a_reservation
{
  var data = {'aaa':'bbb'};
  [self assert: "reservation_data=%7B%22aaa%22%3A%22bbb%22%7D"
        equals: [maker reservationPOSTContentFrom: data]];
}

-(void) test_can_make_route_to_fetch_reservation_by_id
{
  [self assert: '/json/reservation/333'
        equals: [maker fetchReservationRoute: 333]];
}

-(void) test_can_make_route_to_fetch_all_reservations_since_a_certain_date
{
  [self assert: '/reservations/333'
        equals: [maker route_getAllReservations_html: "333"]];
}

-(void) test_can_make_route_to_fetch_animals_with_pending_reservations_on_a_date
{
  [self assert: '/animals_with_pending_reservations?date=2009-12-30'
        equals: [maker pendingReservationAnimalListWithDate: '2009-12-30']];
}

-(void) test_can_make_route_to_fetch_animals_that_can_be_taken_out_of_service_as_of_a_date
{
  [self assert: '/json/animals_that_can_be_taken_out_of_service?date=2009-12-30'
        equals: [maker route_animalsThatCanBeTakenOutOfService_data: '2009-12-30']];
}




@end
