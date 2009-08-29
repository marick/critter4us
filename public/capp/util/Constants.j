@import <AppKit/AppKit.j>

// Notification Names

CourseSessionDescribedNews = "course session described";
ProcedureUpdateNews = "procedures chosen";
ReservationRequestedNews = "reservation requested";
NewReservationNews = "new reservation created";


// Route names
StoreReservationRoute = @"store_reservation";
CourseSessionDataBlobRoute = @"course_session_data_blob";

// Other useful constants
NotificationCenter = [CPNotificationCenter defaultCenter];

// URI
jsonURI = function(route)
{
  return url = "/json/" + route
}
