@import <AppKit/AppKit.j>

// Notification Names

CourseSessionDescribedNews = "course session described";
NewReservationNews = "new reservation";
SessionExclusionsNews = "exclusions";
NeedForSessionDataNews = "need session data";
ProcedureUpdateNews = "procedures chosen";
ReservationRequestedNews = "reservation requested";


// Route names
AllAnimalsRoute = @"all_animals";
AllProceduresRoute = @"procedures";
ExclusionsRoute = @"exclusions";
StoreReservationRoute = @"store_reservation";

// Other useful constants
NotificationCenter = [CPNotificationCenter defaultCenter];

// URI
jsonURI = function(route)
{
  return url = "/json/" + route
}
