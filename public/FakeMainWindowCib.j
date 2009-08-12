@import "Constants.j"
@import "PersistentStore.j"
@import "MainWindowController.j"
@import "CourseSessionController.j"
@import "ProcedureInterfaceController.j"
@import "AnimalInterfaceController.j"
@import "ReservationController.j"
@import "ResultController.j"
@import "CheckboxHacks.j"

@implementation FakeMainWindowCib : CPObject
{
  CPWindow theWindow;
  PersistentStore persistentStore;
  CPArray customObjectsLoaded;
}

+ (void)load
{
  [[[FakeMainWindowCib alloc] init] load];
}

- (void)load
{
  customObjectsLoaded = [[CPArray alloc] init];

  [self loadGlobalPersistentStore];
  [self loadAndConnectWindowController];
  var courseSessionController = [self loadAndConnectCourseSessionController];
  var procedureController = [self loadAndConnectProcedureInterfaceController];
  var animalController = [self loadAndConnectAnimalInterfaceController];
  var reservationController = [self loadAndConnectReservationController];

  reservationController.courseSessionController = courseSessionController;
  reservationController.procedureController = procedureController;
  reservationController.animalController = animalController;

  var resultController = [self loadAndConnectResultController];

  var controllerCoordinator = [self loadAndConnectControllerCoordinator];
  controllerCoordinator.courseSessionController = courseSessionController;
  controllerCoordinator.procedureController = procedureController;
  controllerCoordinator.animalController = animalController;
  controllerCoordinator.reservationController = reservationController;
  controllerCoordinator.resultController = resultController;

  [self awakenAllObjects];
  [theWindow orderFront:self];
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

- (id) loadAndConnectWindowController
{
  theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero()
	       styleMask:CPBorderlessBridgeWindowMask];
  var contentView = [theWindow contentView];

  var mainWindowController = [[MainWindowController alloc] init];
  mainWindowController.theWindow = theWindow;
  [customObjectsLoaded addObject:mainWindowController];
  return mainWindowController;
}

-(id) loadAndConnectCourseSessionController
{  
  var contentView = [theWindow contentView];
  var buildingView = [[CPView alloc] initWithFrame:CGRectMake(0, 0, 900, 120)];
  var finishedView = [[CPView alloc] initWithFrame:CGRectMake(0, 0, 900, 120)];
  [contentView addSubview: finishedView];
  [contentView addSubview: buildingView];
  [finishedView setHidden:YES];

  var label = [[CPTextField alloc] initWithFrame:CGRectMake(10, 40, 500, 30)];
  [label setStringValue: "1. Fill in the information, then click the button."];
  [buildingView addSubview:label];

  var courseLabel = [[CPTextField alloc] initWithFrame:CGRectMake(10, 75, 100, 30)];
  [courseLabel setStringValue: "Course: "];
  [buildingView addSubview:courseLabel];

  var courseField = [[CPTextField alloc] initWithFrame:CGRectMake(60, 70, 100, 30)];
  [courseField setEditable:YES];
  [courseField setBezeled:YES];
  [buildingView addSubview:courseField];

  var instructorLabel = [[CPTextField alloc] initWithFrame:CGRectMake(170, 75, 60, 30)];
  [instructorLabel setStringValue: "Instructor: "];
  [buildingView addSubview:instructorLabel];

  var instructorField = [[CPTextField alloc] initWithFrame:CGRectMake(235, 70, 100, 30)];
  [instructorField setEditable:YES];
  [instructorField setBezeled:YES];
  [buildingView addSubview:instructorField];

  var onLabel = [[CPTextField alloc] initWithFrame:CGRectMake(345, 75, 60, 30)];
  [onLabel setStringValue: "on: "];
  [buildingView addSubview:onLabel];

  var dateField = [[CPTextField alloc] initWithFrame:CGRectMake(370, 70, 100, 30)];
  [dateField setEditable:YES];
  [dateField setBezeled:YES];
  [dateField setStringValue: "2009-"];
  [buildingView addSubview:dateField];

  var morningButton = [[CPRadio alloc] initWithFrame: CGRectMake(480, 67, 100, 20)];
  [morningButton setState:CPOnState];
  [morningButton setTitle:"morning"];
  
  var afternoonButton = [[CPRadio alloc] initWithFrame: CGRectMake(480, 87, 100, 20) radioGroup:[morningButton radioGroup]];
  [afternoonButton setTitle:"afternoon"];

  [buildingView addSubview: morningButton];
  [buildingView addSubview: afternoonButton];
	   
  var goButton = [[CPButton alloc] initWithFrame:CGRectMake(580, 70, 80, 30)];
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
  [instructorField setStringValue: "Morin"];
  [courseField setStringValue: "VM333"];
  [dateField setStringValue: "2009-09-23"];

  [theWindow makeFirstResponder: courseField];
  [dateField setNextKeyView: afternoonButton]; // doesn't work.

  [theWindow setDefaultButton: goButton];
  [theWindow enableKeyEquivalentForDefaultButton];
  [customObjectsLoaded addObject:sessionController];
  return sessionController;
}
  
- (id) loadAndConnectProcedureInterfaceController
{
  var contentView = [[CPView alloc] initWithFrame: CGRectMake(10, 140, 600, 400)];
  [[theWindow contentView] addSubview: contentView];


  var label = [[CPTextField alloc] initWithFrame:CGRectMake(0, 0, 500, 30)];
  [label setStringValue: "2. Click the procedures to be used in the lab."];
  [contentView addSubview:label];

  var note = [[CPTextField alloc] initWithFrame:CGRectMake(0, 20, 600, 30)];
  [note setStringValue: "Animals that may not be used for that procedure will be removed from the table on the far right."];
  [contentView addSubview:note];


  var unchosenProcedureTable = [[CPTableView alloc] initWithFrame: CGRectMake(0, 0, 250, 250)];
  var column = [[CPTableColumn alloc] initWithIdentifier:@"only"];
  [[column headerView] setStringValue: @"procedure"];
  [[column headerView] sizeToFit];
  [column setWidth: 250];
  [unchosenProcedureTable addTableColumn:column];

  var cscrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(0,60,250,250)];
  [cscrollView setDocumentView:unchosenProcedureTable];
  [cscrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
  [contentView addSubview:cscrollView];


  var chosenProcedureTable = [[CPTableView alloc] initWithFrame: CGRectMake(0, 0, 250, 250)];
  var column = [[CPTableColumn alloc] initWithIdentifier:@"only"];
  [[column headerView] setStringValue: @"procedure"];
  [[column headerView] sizeToFit];
  [column setWidth: 250];
  [chosenProcedureTable addTableColumn:column];

  var uscrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(260,60,250,250)];
  [uscrollView setDocumentView:chosenProcedureTable];
  [uscrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
  [contentView addSubview:uscrollView];



  var procedureController = [[ProcedureInterfaceController alloc] init];
  procedureController.persistentStore = persistentStore;
  procedureController.containingView = contentView;

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

  var contentView = [[CPView alloc] initWithFrame: CGRectMake(650, 140, 300, 900)];
  [[theWindow contentView] addSubview: contentView];


  var label = [[CPTextField alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
  [label setStringValue: "3. Check which animals are to be reserved."];
  [contentView addSubview:label];

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
  [contentView addSubview:scrollView];
  [contentView setHidden:YES];

  animalController.persistentStore = persistentStore;
  animalController.containingView = contentView;
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

  var contentView = [[CPView alloc] initWithFrame: CGRectMake(650, 480, 300, 100)];
  [contentView setHidden:YES];
  [[theWindow contentView] addSubview: contentView];

  var reserveLabel = [[CPTextField alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
  [reserveLabel setStringValue: "4. When you're ready to reserve, just click."];
  [contentView addSubview:reserveLabel];

  var reserveButton = [[CPButton alloc] initWithFrame:CGRectMake(80, 30, 80, 30)];
  [reserveButton setTitle: "Reserve"];
  [reserveButton setTarget: reservationController];
  [reserveButton setAction: @selector(makeReservation:)];
  [contentView addSubview:reserveButton];

  reservationController.persistentStore = persistentStore;
  reservationController.containingView = contentView;
  reservationController.button = reserveButton;

  [customObjectsLoaded addObject:reservationController];
  return reservationController;
}

-(id) loadAndConnectResultController
{
  var resultController = [[ResultController alloc] init];
  var contentView = [[CPView alloc] initWithFrame: CGRectMake(600,50,400,50)];
  [contentView setHidden:YES];
  [[theWindow contentView] addSubview: contentView];
  resultController.containingView = contentView;

  var webView = [[CPWebView alloc] initWithFrame: CGRectMake(0,0,400,50)];
  [contentView addSubview: webView];
  //[webView loadHTMLString:@"<a href=\"http://arxta.net\" target=\"_blank\">Click me!</a>" baseURL: nil];

  resultController.link = webView;

  [customObjectsLoaded addObject: resultController];
  return resultController;
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
