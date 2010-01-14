@import "../util/Constants.j"


// TODO: These manifest constants are stupid, given methods below.
CourseSessionDataBlobRoute = @"course_session_data_blob";

StoreReservationRoute = @"store_reservation";
TakeAnimalsOutOfServiceRoute = "take_animals_out_of_service";

FetchReservationRoute = @"reservation";
ModifyReservationRoute = @"modify_reservation";
AllReservationsTableRoute = @"reservations";
AllAnimalsTableRoute = @"animals"; 
PendingAnimalsTableRoute = "animals_with_pending_reservations"

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

- (CPString) reservationRouteWithDate: date time: time
{
  return jsonRoute(CourseSessionDataBlobRoute)+"?date=" + date + "&time=" + time;
}

- (CPString) pendingReservationAnimalListWithDate: date
{
  return htmlRoute(PendingAnimalsTableRoute+"?date=" + date)
}

- (CPString) POSTReservationRoute
{
  return jsonRoute(StoreReservationRoute);
}

- (CPString) POSTContentFrom: (id) jsData
{
  var json = [CPString JSONFromObject: jsData];
  return 'data=' + encodeURIComponent(json);
}

- (CPString) POSTAnimalsOutOfServiceRoute
{
  return jsonRoute(TakeAnimalsOutOfServiceRoute);
}

- (CPString) fetchReservationRoute: id
{
  return jsonRoute(FetchReservationRoute) + '/' + id
}

- (CPString) animalsThatCanBeTakenOutOfServiceRoute: date
{
  return jsonRoute("animals_that_can_be_taken_out_of_service")+"?date=" + date
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
  return jsonRoute(ModifyReservationRoute);
}

- (CPString) POSTContentFrom: (id) jsData
{
  return [super POSTContentFrom: jsData] + '&reservationID=' + reservationBeingEdited;
}

- (CPString) reservationRouteWithDate: date time: time
{
  return [super reservationRouteWithDate: date time: time] + '&ignoring=' + reservationBeingEdited;
}



@end
