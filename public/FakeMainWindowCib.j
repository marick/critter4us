@import "Constants.j"
@import "PersistentStore.j"
@import "MainWindowController.j"
@import "DateInterfaceController.j"
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
  [self loadAndConnectDateInterfaceController];
  [self loadAndConnectProcedureInterfaceController];
  [self loadAndConnectAnimalInterfaceController];
  [self loadAndConnectReservationController];
  [self loadAndConnectResultController];

  [self awakenAllObjects];
  [theWindow orderFront:self];
}


- (void) loadGlobalPersistentStore
{
  persistentStore = [[PersistentStore alloc] init];
  persistentStore.network = [[NetworkConnection alloc] init];
}

- (void) loadAndConnectWindowController
{
  theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero()
	       styleMask:CPBorderlessBridgeWindowMask];
  var contentView = [theWindow contentView];

  var mainWindowController = [[MainWindowController alloc] init];
  mainWindowController.theWindow = theWindow;
  [customObjectsLoaded addObject:mainWindowController];
}

-(void) loadAndConnectDateInterfaceController
{  
  label = [[CPTextField alloc] initWithFrame:CGRectMake(10, 40, 500, 30)];
  [label setStringValue: "1. Type in the date of your lab. (You can just press Return to accept the date shown.)"];
  [[theWindow contentView] addSubview:label];

  dateField = [[CPTextField alloc] initWithFrame:CGRectMake(10, 70, 250, 30)];
  [dateField setEditable:YES];
  [dateField setBezeled:YES];
  [dateField setStringValue: "2009-07-23"];
  [[theWindow contentView] addSubview:dateField];
  [theWindow makeFirstResponder: dateField];

  var dateController = [[DateInterfaceController alloc] init];
  dateController.persistentStore = persistentStore;

  [dateField setTarget: dateController];
  [dateField setAction: @selector(newDate:)];
  [customObjectsLoaded addObject:dateController];
}
  
- (void) loadAndConnectProcedureInterfaceController
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
}

-(void)loadAndConnectAnimalInterfaceController
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
}


-(void)loadAndConnectReservationController
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
}

-(void) loadAndConnectResultController
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
