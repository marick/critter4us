@import <AppKit/AppKit.j>

// Notification Names

UserWantsToAddAnAnimal = "user wants to add animal";
UserWantsToReplaceTimeslice = "wants to replace timeslice";
UserHasChosenTimeslice = "user has chosen timeslice";
DifferentObjectsUsedNews = "Some difference in use";
AnimalAndProcedureNews = "animals, objects, and exclusions";
TimeToReserveNews = "time to reserve";
SwitchToGroupNews = "switch to this group";
ModifyReservationNews = "time to edit a reservation";
CopyReservationNews = "time to copy a reservation";
TimesliceForCurrentReservationChangedNews = 'date and time have changed'
AdviceAboutAnimalsDroppedNews = "animals have been dropped due to time or date change";
NewAdvisorPanelOnPageNews = "a new advisor panel has appeared";
ClosedAdvisorPanelOnPageNews = "a panel on the current page has closed";
AdvisoriesAreIrrelevantNews = "advisory panels should go away";
ReservationStoredNews = "reservation has been stored";
ReservationRetrievedNews = "reservation has been retrieved";
BusyNews = "hold on user";
AvailableNews = "your turn";
AllReservationsHtmlNews = "a reservation table has been retrieved";

// TODO: I'm moving away from suffix "News", since it adds nothing. That the 
// constant is "news" is clear from context.
UserWantsAnimalsThatCanBeRemovedFromService = "user wants list of animals in service on particular date"
AnimalsThatCanBeRemovedFromServiceRetrieved = "deletion info has been retrieved";
AnimalsToRemoveFromServiceNews = "user has chosen animals to take out of service";
RestartAnimalRemovalStateMachineNews = "probably want to pick a new date for taking out of service";
TableOfAnimalsWithPendingReservationsNews = "these cannot be put out of service"

// Following used when a method that doesn't want to provoke a
// notification must call a method that takes a notification name.
UniversallyIgnoredNews = "No objects listen for this";

// Other useful constants

NotificationCenter = [CPNotificationCenter defaultCenter];

// Standard window and view size information
WindowBottomMargin = 20;
ScrollbarWidth = 20;
TextLineHeight = 20;
CompleteTextLineWidth = 250-ScrollbarWidth;
TruncatedTextLineWidth = 200;


// Misc
UnusedArgument = nil;

