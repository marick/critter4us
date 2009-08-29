@import "../util/AwakeningObject.j"

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
   selector: @selector(switchToAnimalChoosing:)
   name: CourseSessionDescribedNews
   object: nil];

  [NotificationCenter
   addObserver: self
   selector: @selector(makeReservation:)
   name: ReservationRequestedNews
   object: nil];

  [NotificationCenter
   addObserver: self
   selector: @selector(chosenProceduresChanged:)
   name: ProcedureUpdateNews
   object: nil];
}

- (void) switchToAnimalChoosing: (CPNotification) ignored
{
  [courseSessionController displaySelectedSession];

  var dict = [CPMutableDictionary dictionary];
  [courseSessionController spillIt: dict];

  [persistentStore focusOnDate: [dict valueForKey: 'date']
                          time: [dict valueForKey: 'time']];

  [animalController beginUsingAnimals: persistentStore.allAnimalNames
                          withKindMap: persistentStore.kindMap];
  [animalController showViews];

  [procedureController beginUsingProcedures: persistentStore.allProcedureNames];
  [procedureController showViews];

  [reservationController showViews];
  [resultController hideViews];
}

- (void) chosenProceduresChanged: aNotification
{
  var procedures = [aNotification object];
  var animalsToRemove = [self animalsExcludedBy: procedures];
  [animalController withholdAnimals: animalsToRemove];
}

- (void) makeReservation: (CPNotification) ignored
{
  var dict = [CPMutableDictionary dictionary];
  [courseSessionController spillIt: dict];
  [procedureController spillIt: dict];
  [animalController spillIt: dict];

  var reservationID = [persistentStore makeReservation: dict];
  
  [resultController offerReservationView: reservationID];
  [resultController showViews];

  [courseSessionController makeViewsAcceptData];
  [animalController hideViews];
  [procedureController hideViews];
  [reservationController hideViews];
}

// util

- (CPArray) animalsExcludedBy: procedures
{
  var building = [CPMutableSet set];
  for (var i=0; i<[procedures count]; i++)
    {
      [self addAnimalsTo: building whenExcludedBy: [procedures objectAtIndex: i]];
    }
  var retval = [building allObjects]
  [retval sortUsingSelector: @selector(caseInsensitiveCompare:)]; // for testing
  return retval;
}
  
- (void) addAnimalsTo: (CPMutableSet) animalSet whenExcludedBy: (CPString) procedure
{
  var excludedAnimals = [persistentStore.exclusions objectForKey: procedure];
  [animalSet addObjectsFromArray: excludedAnimals];
}

@end
