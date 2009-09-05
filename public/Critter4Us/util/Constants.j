@import <AppKit/AppKit.j>

// Notification Names

// TODO: these need to be deleted after new implementation finished
CourseSessionDescribedNews = "course session described";
ProcedureUpdateNews = "procedures chosen";
ReservationRequestedNews = "reservation requested";
NewReservationNews = "new reservation created";

// TODO: these are tne new ones
ReservationDataCollectedNews = "reservation data collected";
ProcedureChangeNews = "procedures have changed";
GroupingsDataCollectedNews = "all reservation data is ready now";
OneAnimalChosenNews = "one animal has been chosen";


// Route names
StoreReservationRoute = @"store_reservation";
CourseSessionDataBlobRoute = @"course_session_data_blob";
AllReservationsTableRoute = @"reservations";

// Other useful constants
NotificationCenter = [CPNotificationCenter defaultCenter];

// URI
jsonURI = function(route)
{
  return url = "/json/" + route
}

// Drag and drop
ProcedureDragType = "ProcedureDragType";
AnimalDragType = "AnimalDragType";
