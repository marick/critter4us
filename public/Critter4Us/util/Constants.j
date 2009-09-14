@import <AppKit/AppKit.j>

// Notification Names

// TODO: these need to be deleted after new implementation finished
CourseSessionDescribedNews = "course session described";
ProcedureUpdateNews = "procedures chosen";
ReservationRequestedNews = "reservation requested";
NewReservationNews = "new reservation created";

// TODO: these are tne new ones
ReservationDataAvailable="Reservation data available";
ProceduresChosenNews = "These procedures have been chosen";
InitialDataForACourseSessionNews = "course focus data has arrived"

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


// Standard window and view size information
WindowBottomMargin = 20;
ScrollbarWidth = 20;
TextLineHeight = 20;
CompleteTextLineWidth = 250-ScrollbarWidth;
TruncatedTextLineWidth = 200;


// Misc
UnusedArgument = nil;
