@import "AwakeningObject.j"

@implementation ControllerCoordinator : AwakeningObject
{
  ResultController resultController;
  ReservationController reservationController;
  AnimalController animalController;
  ProcedureController procedureController;
  CourseSessionController courseSessionController;
  PersistentStore persistentStore;
}


-(void) awakeFromCib
{
  if (awakened) return;
  [super awakeFromCib];
  [courseSessionController makeViewsAcceptData];
  [animalController hideViews];
  [procedureController hideViews];
  [reservationController hideViews];
  [resultController hideViews];
}

- (void) setUpNotifications
{
  [super setUpNotifications];

  [NotificationCenter
   addObserver: self
   selector: @selector(makeReservation:)
   name: ReservationRequestedNews
   object: nil];
}

- (void) makeReservation: (CPButton) sender
{
  var dict = [CPMutableDictionary dictionary];
  [courseSessionController spillIt: dict];
  [procedureController spillIt: dict];
  [animalController spillIt: dict];

  var reservationID = [persistentStore makeReservation: dict];
  
  [resultController offerReservationView: reservationID];
  [resultController showViews];
}


@end
