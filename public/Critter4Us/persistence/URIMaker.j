@import "../util/Constants.j"

CourseSessionDataBlobRoute = @"course_session_data_blob";
InServiceAnimalListBlogRoute = @"animals_in_service_blob";

StoreReservationRoute = @"store_reservation";
TakeAnimalsOutOfServiceRoute = "take_animals_out_of_service";

FetchReservationRoute = @"reservation";
ModifyReservationRoute = @"modify_reservation";
AllReservationsTableRoute = @"reservations";
AllAnimalsTableRoute = @"animals"; 
PendingAnimalsTableRoute = "animals_with_pending_reservations"

jsonURI = function(route)
{
  return url = "/json/" + route
}

htmlURI = function(route)
{
  return '/' + route
}

@implementation URIMaker : CPObject

- (CPString) reservationURIWithDate: date time: time
{
  return jsonURI(CourseSessionDataBlobRoute)+"?date=" + date + "&time=" + time;
}

- (CPString) inServiceAnimalListWithDate: date
{
  return jsonURI(InServiceAnimalListBlogRoute)+"?date=" + date
}

- (CPString) pendingReservationAnimalListWithDate: date
{
  return htmlURI(PendingAnimalsTableRoute+"?date=" + date)
}

- (CPString) POSTReservationURI
{
  return jsonURI(StoreReservationRoute);
}

- (CPString) POSTContentFrom: (id) jsData
{
  var json = [CPString JSONFromObject: jsData];
  return 'data=' + encodeURIComponent(json);
}

- (CPString) POSTAnimalsOutOfServiceURI
{
  return jsonURI(TakeAnimalsOutOfServiceRoute);
}

- (CPString) fetchReservationURI: id
{
  return jsonURI(FetchReservationRoute) + '/' + id
}



@end



@implementation EditingURIMaker : URIMaker
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

- (CPString) fetchReservationURI: id
{
  return [super fetchReservationURI: id] + '?ignoring=' + reservationBeingEdited ;
}

- (CPString) POSTReservationURI
{
  return jsonURI(ModifyReservationRoute);
}

- (CPString) POSTContentFrom: (id) jsData
{
  return [super POSTContentFrom: jsData] + '&reservationID=' + reservationBeingEdited;
}

- (CPString) reservationURIWithDate: date time: time
{
  return [super reservationURIWithDate: date time: time] + '&ignoring=' + reservationBeingEdited;
}


@end
