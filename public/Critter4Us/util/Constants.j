@import <AppKit/AppKit.j>

// Notification Names

ReservationDataAvailable="Reservation data available";
DifferentObjectsUsedNews = "Some difference in use";
AnimalAndProcedureNews = "animals, objects, and exclusions";
TimeToReserveNews = "time to reserve";
SwitchToGroupNews = "switch to this group";
ModifyReservationNews = "time to edit a reservation";
CopyReservationNews = "time to copy a reservation";
DateTimeForCurrentReservationChangedNews = 'date and time have changed'
AdviceAboutAnimalsDroppedNews = "animals have been dropped due to time or date change";
NewPanelOnPageNews = "a new panel has appeared on the current page";
ClosedPanelOnPageNews = "a panel on the current page has closed";
AdvisoriesAreIrrelevantNews = "advisory panels should go away";
ReservationStoredNews = "reservation has been stored"

// Route names
AllReservationsTableRoute = @"reservations";
GetEditableReservationRoute = @"reservation";
ModifyReservationRoute = @"modify_reservation";

// Other useful constants
NotificationCenter = [CPNotificationCenter defaultCenter];

// URI
jsonURI = function(route)
{
  return url = "/json/" + route
}

// Standard window and view size information
WindowBottomMargin = 20;
ScrollbarWidth = 20;
TextLineHeight = 20;
CompleteTextLineWidth = 250-ScrollbarWidth;
TruncatedTextLineWidth = 200;


// Misc
UnusedArgument = nil;
