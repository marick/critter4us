@import "../util/AwakeningObject.j"
@import "PMRPageController.j"
@import "PMRGroupingsController.j"
@import "ReservationDataController.j"


@implementation CoordinatorPMR : AwakeningObject
{
  ReservationDataController reservationDataController;
  AnimalControllerPMR animalController;
  ProcedureControllerPMR procedureController;
  PMRGroupingsController groupingsController;
  PMRPageController pageController;
}


-(void) awakeFromCib
{
  [super awakeFromCib];
  [reservationDataController allowUserToChooseParticularCourseSession];
  [groupingsController hideViews];
  [pageController hideFloatingWindows];
  [pageController setDisplayFloatingWindowsOnPageReveal: NO];
}

- (void) setUpNotifications
{
  [super setUpNotifications];

  [NotificationCenter
   addObserver: self
   selector: @selector(switchToAnimalChoosing:)
   name: ReservationDataCollectedNews
   object: nil];

  [NotificationCenter
   addObserver: self
   selector: @selector(makeReservation:)
   name: GroupingsDataCollectedNews
   object: nil];

  [NotificationCenter
   addObserver: self
   selector: @selector(chosenProceduresChanged:)
   name: ProcedureChangeNews
   object: nil];
}

- (void) switchToAnimalChoosing: (CPNotification) ignored
{
  [reservationDataController commitToParticularCourseSession];
  [groupingsController showViews];
  [pageController showFloatingWindows];
  [pageController setDisplayFloatingWindowsOnPageReveal: YES];

  var dict = [CPMutableDictionary dictionary];
  [reservationDataController spillIt: dict];

  [persistentStore focusOnDate: [dict valueForKey: 'date']
                          time: [dict valueForKey: 'time']];

  [animalController beginUsingAnimals: persistentStore.allAnimalNames
                          withKindMap: persistentStore.kindMap];

  [procedureController beginUsingProcedures: persistentStore.allProcedureNames];
}

- (void) chosenProceduresChanged: (CPNotification) aNotification
{
  var procedures = [aNotification object];
  var animalsToRemove = [self animalsExcludedBy: procedures];
  [animalController withholdAnimals: animalsToRemove];
}

- (void) makeReservation: (CPNotification) ignored
{
  var dict = [CPMutableDictionary dictionary];
  [reservationDataController spillIt: dict];
  [procedureController spillIt: dict];
  [animalController spillIt: dict];

  var reservationID = [persistentStore makeReservation: dict];
  
  [reservationDataController offerReservationView: reservationID];

  [reservationDataController allowUserToChooseParticularCourseSession];
  [groupingsController hideViews];
  [pageController hideFloatingWindows];
  [pageController setDisplayFloatingWindowsOnPageReveal:NO];
  [procedureController hideViews];
  [reservationDataController hideViews];
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
