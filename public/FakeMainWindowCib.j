@import "PersistentStore.j"
@import "MainWindowController.j"
@import "DateInterfaceController.j"
@import "ProcedureInterfaceController.j"
@import "AnimalInterfaceController.j"

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

  [self awakenAllObjects];
  [theWindow orderFront:self];
}


- (void) loadGlobalPersistentStore
{
  persistentStore = [[PersistentStore alloc] init];
  persistentStore.connection = [[Network alloc] init];
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
  [label setStringValue: "First, type in the date of your lab. (You can just press Return to accept the date shown.)"];
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
  [label setStringValue: "Next, click the procedure you want to see which animals are available."];
  [contentView addSubview:label];


  var note = [[CPTextField alloc] initWithFrame:CGRectMake(0, 20, 500, 30)];
  [note setStringValue: "(Only venipuncture will do anything interesting.)"];
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
  var animalTable = [[CPTableView alloc] initWithFrame: CGRectMake(0, 0, 250, 250)];
  var checkColumn = [[CPTableColumn alloc] initWithIdentifier:@"checks"];
  [checkColumn setWidth: 20];
  var checkButton = [[CPCheckBox alloc] init];
  [checkColumn setDataCell: checkButton]
  [animalTable addTableColumn:checkColumn];

  var nameColumn = [[CPTableColumn alloc] initWithIdentifier:@"names"];
  [nameColumn setWidth: 230];
  [animalTable addTableColumn:nameColumn];

  var scrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(650,200,250,250)];
  [scrollView setDocumentView:animalTable];
  [scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
  [[theWindow contentView] addSubview:scrollView];
  [scrollView setHidden:YES];

  var animalController = [[AnimalInterfaceController alloc] init];
  animalController.persistentStore = persistentStore;
  animalController.containingView = scrollView;
  animalController.nameColumn = nameColumn;
  animalController.checkColumn = checkColumn;

  animalController.table = animalTable;
  [animalTable setDataSource: animalController];
  [animalTable setDelegate:animalController];

  [customObjectsLoaded addObject:animalController];
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
