@import "../util/Constants.j"

CourseSessionDataBlobRoute = @"course_session_data_blob";
StoreReservationRoute = @"store_reservation";
FetchReservationRoute = @"reservation";

@implementation URIMaker : CPObject

- (CPString) reservationURIWithDate: date time: time
{
  return jsonURI(CourseSessionDataBlobRoute)+"?date=" + date + "&time=" + time;
}

- (CPString) POSTReservationContentFrom: (id) jsData
{
  var json = [CPString JSONFromObject: jsData];
  return 'data=' + encodeURIComponent(json);
}


- (CPString) POSTReservationURI
{
  return jsonURI(StoreReservationRoute);
}

@end



@implementation EditingURIMaker : URIMaker
{
  id reservationID;
}

- (id) initEditing: aReservationID
{
  self = [super init];
  reservationID = aReservationID;
  return self;
}

- (id) reservationID
{
  return reservationID;
}

- (CPString) fetchReservationURI: id
{
  return jsonURI(FetchReservationRoute) + '/' + id + '?ignoring=' + id ;
}


@end
