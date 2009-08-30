@import "../util/Constants.j"
@import "../persistence/PersistentStore.j"
@import "../controller/CourseSessionController.j"
@import "../controller/ProcedureInterfaceController.j"
@import "../controller/AnimalInterfaceController.j"
@import "../controller/ReservationController.j"
@import "../controller/ResultController.j"
@import "../controller/ControllerCoordinator.j"
@import "../util/CheckboxHacks.j"
@import "../controller/MakeReservationPageController.j"

@implementation MakeReservationPageCib : CPObject
{
  CPView pageView;
  CPObject pageController;
  PersistentStore persistentStore;
  CPArray customObjectsLoaded;
  CPResponder desiredFirstResponder;
}

- (void)instantiatePageInWindow: (CPWindow) window withOwner: (CPObject) owner
{
	var containingView = [window contentView];
	pageView = [[CPView alloc] initWithFrame: [containingView frame]];
  [containingView addSubview: pageView];

	pageController = [[MakeReservationPageController alloc] init];
	pageController.pageView = pageView;
	owner.makeReservationPageController = pageController;
	
	[self connect];
}


- (void)connect
{
  customObjectsLoaded = [[CPArray alloc] init];

  [self loadGlobalPersistentStore];
  var courseSessionController = [self loadAndConnectCourseSessionController];
  var procedureController = [self loadAndConnectProcedureInterfaceController];
  var animalController = [self loadAndConnectAnimalInterfaceController];
  var reservationController = [self loadAndConnectReservationController];

  var resultController = [self loadAndConnectResultController];

  var controllerCoordinator = [self loadAndConnectControllerCoordinator];
  controllerCoordinator.courseSessionController = courseSessionController;
  controllerCoordinator.procedureController = procedureController;
  controllerCoordinator.animalController = animalController;
  controllerCoordinator.reservationController = reservationController;
  controllerCoordinator.resultController = resultController;
  controllerCoordinator.persistentStore = persistentStore;

  [self awakenAllObjects];
}

- (void) loadControllerCoordinator
{
  var controllerCoordinator = [[ControllerCoordinator alloc] init];

  [customObjectsLoaded addObject:controllerCoordinator];
  return controllerCoordinator;
}


- (void) loadGlobalPersistentStore
{
  persistentStore = [[PersistentStore alloc] init];
  persistentStore.network = [[NetworkConnection alloc] init];
}

-(id) loadAndConnectCourseSessionController
{  
  var myView = pageView;
  var buildingView = [[CPView alloc] initWithFrame:CGRectMake(0, 0, 900, 120)];
  var finishedView = [[CPView alloc] initWithFrame:CGRectMake(0, 0, 900, 120)];
  [myView addSubview: finishedView];
  [myView addSubview: buildingView];
  [finishedView setHidden:YES];

  var instructionLabel = [[CPTextField alloc] initWithFrame:CGRectMake(10, 30, 400, 30)];
  [instructionLabel setStringValue: "1. Fill in the information, then click the button."];
  [buildingView addSubview: instructionLabel];


  var x = 10;
  var width = 45
  var courseLabel = [[CPTextField alloc] initWithFrame:CGRectMake(x, 75, width, 30)];
  [courseLabel setStringValue: "Course: "];
  [buildingView addSubview:courseLabel];
  x += width;

  width = 100;
  var courseField = [[CPTextField alloc] initWithFrame:CGRectMake(x, 70, width, 30)];
  [courseField setEditable:YES];
  [courseField setBezeled:YES];
  [buildingView addSubview:courseField];
  x+= width;

  x += 10;
  width = 90;
  var instructorLabel = [[CPTextField alloc] initWithFrame:CGRectMake(x, 75, width, 30)];
  [instructorLabel setStringValue: "Instructor NetID: "];
  [buildingView addSubview:instructorLabel];
  x += width;

  width = 100;
  var instructorField = [[CPTextField alloc] initWithFrame:CGRectMake(x, 70, width, 30)];
  [instructorField setEditable:YES];
  [instructorField setBezeled:YES];
  [buildingView addSubview:instructorField];
  x += width;

  x += 10;
  width = 20;
  var onLabel = [[CPTextField alloc] initWithFrame:CGRectMake(x, 75, width, 30)];
  [onLabel setStringValue: "on: "];
  [buildingView addSubview:onLabel];
  x += width;

  width = 100;
  var dateField = [[CPTextField alloc] initWithFrame:CGRectMake(x, 70, width, 30)];
  [dateField setEditable:YES];
  [dateField setBezeled:YES];
  [dateField setStringValue: "2009-"];
  [buildingView addSubview:dateField];
  x += width;

  x += 10;
  width = 100
  var morningButton = [[CPRadio alloc] initWithFrame: CGRectMake(x, 67, width, 20)];
  [morningButton setState:CPOnState];
  [morningButton setTitle:"morning"];
  
  var afternoonButton = [[CPRadio alloc] initWithFrame: CGRectMake(x, 87, width, 20) radioGroup:[morningButton radioGroup]];
  [afternoonButton setTitle:"afternoon"];

  [buildingView addSubview: morningButton];
  [buildingView addSubview: afternoonButton];
  x += width;
    
  x += 15;
  width = 80;
  var goButton = [[CPButton alloc] initWithFrame:CGRectMake(x, 70, width, 30)];
  [goButton setTitle: "Begin"];
  [buildingView addSubview:goButton];

  var summaryField = [[CPTextField alloc] initWithFrame:CGRectMake(10, 45, 500, 30)];
  [finishedView addSubview: summaryField];
  
  var sessionController = [[CourseSessionController alloc] init];
  sessionController.persistentStore = persistentStore;
  sessionController.courseField = courseField;
  sessionController.instructorField = instructorField;
  sessionController.dateField = dateField;
  sessionController.morningButton = morningButton;
  sessionController.summaryField = summaryField;
  sessionController.buildingView = buildingView;
  sessionController.finishedView = finishedView;

  [goButton setTarget: sessionController];
  [goButton setAction: @selector(sessionReady:)];

  // Temporary for testing
  [instructorField setStringValue: "morin"];
  [courseField setStringValue: "VM333"];
  [dateField setStringValue: "2009-09-23"];

	[pageController setDesiredFirstResponder:courseField];
  [courseField setNextKeyView: dateField];
  [dateField setNextKeyView: afternoonButton];

  // Doesn't work.
  //  [theWindow setDefaultButton: goButton];
  //  [theWindow enableKeyEquivalentForDefaultButton];
  [customObjectsLoaded addObject:sessionController];
  return sessionController;
}
  
- (id) loadAndConnectProcedureInterfaceController
{
  var myView = [[CPView alloc] initWithFrame: CGRectMake(10, 140, 600, 400)];
  [pageView addSubview: myView];


  var label = [[CPTextField alloc] initWithFrame:CGRectMake(0, 0, 500, 30)];
  [label setStringValue: "2. Click the procedures to be used in the lab."];
  [myView addSubview:label];

  var note = [[CPTextField alloc] initWithFrame:CGRectMake(0, 20, 600, 30)];
  [note setStringValue: "Animals that may not be used for that procedure will be removed from the table on the far right."];
  [myView addSubview:note];


  var unchosenProcedureTable = [[CPTableView alloc] initWithFrame: CGRectMake(0, 0, 250, 250)];
  var column = [[CPTableColumn alloc] initWithIdentifier:@"only"];
  [[column headerView] setStringValue: @"procedure"];
  [[column headerView] sizeToFit];
  [column setWidth: 250];
  [unchosenProcedureTable addTableColumn:column];

  var cscrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(0,60,250,250)];
  [cscrollView setDocumentView:unchosenProcedureTable];
  [cscrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
  [myView addSubview:cscrollView];


  var chosenProcedureTable = [[CPTableView alloc] initWithFrame: CGRectMake(0, 0, 250, 250)];
  var column = [[CPTableColumn alloc] initWithIdentifier:@"only"];
  [[column headerView] setStringValue: @"procedure"];
  [[column headerView] sizeToFit];
  [column setWidth: 250];
  [chosenProcedureTable addTableColumn:column];

  var uscrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(260,60,250,250)];
  [uscrollView setDocumentView:chosenProcedureTable];
  [uscrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
  [myView addSubview:uscrollView];



  var procedureController = [[ProcedureInterfaceController alloc] init];
  procedureController.persistentStore = persistentStore;
  procedureController.containingView = myView;

  procedureController.unchosenProcedureTable = unchosenProcedureTable;
  [unchosenProcedureTable setDataSource: procedureController];
  [unchosenProcedureTable setDelegate:procedureController];
  [unchosenProcedureTable setTarget: procedureController];
  [unchosenProcedureTable setAction: @selector(chooseProcedure:)];

  procedureController.chosenProcedureTable = chosenProcedureTable;
  [chosenProcedureTable setDataSource: procedureController];
  [chosenProcedureTable setDelegate:procedureController];
  [chosenProcedureTable setTarget: procedureController];
  [chosenProcedureTable setAction: @selector(unchooseProcedure:)];

  [customObjectsLoaded addObject:procedureController];
  return procedureController;
}

-(id)loadAndConnectAnimalInterfaceController
{
  var animalController = [[AnimalInterfaceController alloc] init];
  GlobalCheckboxTarget = animalController;

  var myView = [[CPView alloc] initWithFrame: CGRectMake(650, 140, 300, 900)];
  [pageView addSubview: myView];


  var label = [[CPTextField alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
  [label setStringValue: "3. Check which animals are to be reserved."];
  [myView addSubview:label];

   var animalTable = [[CPTableView alloc] initWithFrame: CGRectMake(0, 0, 250, 250)];
  var checkColumn = [[CheckboxTableColumn alloc] initWithIdentifier:@"checks"];
  [checkColumn setWidth: 20];
  [animalTable addTableColumn:checkColumn];

  var checkButton = [[CritterCheckBox alloc] init];
  [checkButton setTarget: animalController];
  [checkButton setAction: @selector(toggleAnimal:)];
  [checkColumn setDataCell: checkButton]

  var nameColumn = [[CPTableColumn alloc] initWithIdentifier:@"names"];
  [nameColumn setWidth: 230];
  [animalTable addTableColumn:nameColumn];

  var scrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(0,60,250,250)];
  [scrollView setDocumentView:animalTable];
  [scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
  [myView addSubview:scrollView];
  [myView setHidden:YES];

  animalController.persistentStore = persistentStore;
  animalController.containingView = myView;
  animalController.nameColumn = nameColumn;
  animalController.checkColumn = checkColumn;

  animalController.table = animalTable;
  [animalTable setTarget: animalController];
  [animalTable setAction: @selector(toggleAnimal:)];
  [animalTable setDataSource: animalController];
  [animalTable setDelegate:animalController];

  [customObjectsLoaded addObject:animalController];
  return animalController;
}


-(id)loadAndConnectReservationController
{
  var reservationController = [[ReservationController alloc] init];

  var myView = [[CPView alloc] initWithFrame: CGRectMake(650, 480, 300, 100)];
  [myView setHidden:YES];
  [pageView addSubview: myView];

  var reserveLabel = [[CPTextField alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
  [reserveLabel setStringValue: "4. When you're ready to reserve, just click."];
  [myView addSubview:reserveLabel];

  var reserveButton = [[CPButton alloc] initWithFrame:CGRectMake(80, 30, 80, 30)];
  [reserveButton setTitle: "Reserve"];
  [reserveButton setTarget: reservationController];
  [reserveButton setAction: @selector(makeReservation:)];
  [myView addSubview:reserveButton];

  reservationController.containingView = myView;
  reservationController.button = reserveButton;

  [customObjectsLoaded addObject:reservationController];
  return reservationController;
}

-(id) loadAndConnectResultController
{
  var resultController = [[ResultController alloc] init];
  var myView = [[CPView alloc] initWithFrame: CGRectMake(100,250,400,50)];
  [myView setHidden:YES];
  [pageView addSubview: myView];
  resultController.containingView = myView;

  var webView = [[CPWebView alloc] initWithFrame: CGRectMake(0,0,400,50)];
  [myView addSubview: webView];
  //[webView loadHTMLString:@"<a href=\"http://arxta.net\" target=\"_blank\">Click me!</a>" baseURL: nil];

  resultController.link = webView;

  [customObjectsLoaded addObject: resultController];
  return resultController;
}

-(id) loadAndConnectControllerCoordinator
{
  var coordinator = [[ControllerCoordinator alloc] init];
  [customObjectsLoaded addObject: coordinator];
  return coordinator;
}

- (void) awakenAllObjects
{
  for(i=0; i < [customObjectsLoaded count]; i++)
    {
      var obj = [customObjectsLoaded objectAtIndex: i];
      if ([obj respondsToSelector: @selector(awakeFromCib)])
	{
	  [obj awakeFromCib];
	}
    }
}
@end
