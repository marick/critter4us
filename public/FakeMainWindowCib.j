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
  label = [[CPTextField alloc] initWithFrame:CGRectMake(10, 40, 250, 30)];
  [label setStringValue: "What date is your lab?"];
  [[theWindow contentView] addSubview:label];

  dateField = [[CPTextField alloc] initWithFrame:CGRectMake(10, 70, 250, 30)];
  [dateField setEditable:YES];
  [dateField setBezeled:YES];
  [dateField setStringValue: "2009-07-23"];
  [[theWindow contentView] addSubview:dateField];

  var dateController = [[DateInterfaceController alloc] init];
  dateController.persistentStore = persistentStore;

  [dateField setTarget: dateController];
  [dateField setAction: @selector(newDate:)];
  [customObjectsLoaded addObject:dateController];
}
  
- (void) loadAndConnectProcedureInterfaceController
{
  var procedureTable = [[CPTableView alloc] initWithFrame: CGRectMake(0, 0, 250, 250)];
  var column = [[CPTableColumn alloc] initWithIdentifier:@"only"];
  [[column headerView] setStringValue: @"procedure"];
  [[column headerView] sizeToFit];
  [column setWidth: 250];
  [procedureTable addTableColumn:column];

  var scrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(10,110,250,250)];
  [scrollView setDocumentView:procedureTable];
  [scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
  [[theWindow contentView] addSubview:scrollView];


  var procedureController = [[ProcedureInterfaceController alloc] init];
  procedureController.persistentStore = persistentStore;

  procedureController.table = procedureTable;
  [procedureTable setDataSource: procedureController];
  [procedureTable setDelegate:procedureController];
  [procedureTable setTarget: procedureController];
  [procedureTable setAction: @selector(chooseProcedure:)];

  [customObjectsLoaded addObject:procedureController];
}

-(void)loadAndConnectAnimalInterfaceController
{
  var animalTable = [[CPTableView alloc] initWithFrame: CGRectMake(0, 0, 250, 250)];
  var column = [[CPTableColumn alloc] initWithIdentifier:@"only"];
  [column setWidth: 250];
  [animalTable addTableColumn:column];

  var scrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(400,110,250,250)];
  [scrollView setDocumentView:animalTable];
  [scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
  [[theWindow contentView] addSubview:scrollView];

  var animalController = [[AnimalInterfaceController alloc] init];
  animalController.persistentStore = persistentStore;

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
