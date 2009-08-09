// Notification Names

DateChosenNews = "date chosen";
NewReservationNews = "new reservation";


// Route names
AllAnimalsRoute = @"all_animals";
AllProceduresRoute = @"procedures";
ExclusionsRoute = @"exclusions";
StoreReservationRoute = @"store_reservation";

// URI
Site = "http://localhost:7000"

jsonURI = function(route)
{
  return url = Site + "/json/" + route
}
