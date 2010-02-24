@import "../util/Constants.j"


jsonRoute = function(route)
{
  return "/json/" + route
}

htmlRoute = function(route)
{
  return '/' + route
}


@implementation HTTPMaker : CPObject
{
}

- (CPString) route_getAllReservations_html
{
  return htmlRoute("reservations");
}

- (CPString) route_animalsThatCanBeTakenOutOfService_data: date
{
  return jsonRoute("animals_that_can_be_taken_out_of_service")+"?date=" + date
}



- (CPString) animalsAndProceduresAvailableAtTimeslice: primitivizedTimeslice
{
  return jsonRoute("animals_and_procedures_blob")+"?timeslice=" + [CPString JSONFromObject: primitivizedTimeslice];
}

- (CPString) pendingReservationAnimalListWithDate: date
{
  return htmlRoute("animals_with_pending_reservations"+"?date=" + date)
}

- (CPString) POSTReservationRoute
{
  return jsonRoute("store_reservation");
}

- (CPString) POSTContentFrom: (id) jsData
{
  var json = [CPString JSONFromObject: jsData];
  return 'data=' + encodeURIComponent(json);
}

- (CPString) POSTAnimalsOutOfServiceRoute
{
  return jsonRoute("take_animals_out_of_service");
}

- (CPString) fetchReservationRoute: id
{
  return jsonRoute("reservation") + '/' + id
}

@end

@implementation EditingHTTPMaker : HTTPMaker
{
  id reservationBeingEdited;
}

- (id) initEditing: aReservationID
{
  self = [super init];
  reservationBeingEdited = aReservationID;
  return self;
}

- (id) reservationBeingEdited
{
  return reservationBeingEdited;
}

- (CPString) fetchReservationRoute: id
{
  return [super fetchReservationRoute: id] + '?ignoring=' + reservationBeingEdited ;
}

- (CPString) POSTReservationRoute
{
  return jsonRoute("modify_reservation");
}

- (CPString) POSTContentFrom: (id) jsData
{
  return [super POSTContentFrom: jsData] + '&reservationID=' + reservationBeingEdited;
}

- (CPString) animalsAndProceduresAvailableAtTimeslice: primitivizedTimeslice
{
  return [super animalsAndProceduresAvailableAtTimeslice: primitivizedTimeslice] + 
    '&ignoring=' + reservationBeingEdited;
}



@end
