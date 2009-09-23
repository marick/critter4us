@import <AppKit/AppKit.j>

// Notification Names

ReservationDataAvailable="Reservation data available";
DifferentObjectsUsedNews = "Some difference in use";
InitialDataForACourseSessionNews = "course focus data has arrived";
TimeToReserveNews = "time to reserve";
SwitchToGroupNews = "switch to this group";
ModifyReservationNews = "time to edit a reservation";

// Route names
StoreReservationRoute = @"store_reservation";
CourseSessionDataBlobRoute = @"course_session_data_blob";
AllReservationsTableRoute = @"reservations";
GetEditableReservationRoute = @"reservation";

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
