@import <AppKit/AppKit.j>
@import "../util/Constants.j"
@import "../view/DropTarget.j"
@import "../persistence/PersistentStore.j"
@import "ConstantsPMR.j"
@import "DragListPMR.j"
@import "PageControllerPMR.j"
@import "GroupingsControllerPMR.j"
@import "AnimalControllerPMR.j"
@import "ProcedureControllerPMR.j"
@import "ReservationDataControllerPMR.j"
@import "CoordinatorPMR.j"

  // TODO: Hook up to real controller.
FakeProcedures = [ @"castration",
                        @"floating",
                        @"rumen fluid collection (rumenocentesis)",
                        @"blah",
                        @"blah",
                        @"blah",
                        @"blah",
                        @"blah",
                        @"blah",
                        @"blah",
                        @"blah",
                        @"blah",
                        @"blah",
                        @"blah",
                        @"blah",
                        @"blah",
                        @"blah",
                    @"blah"
                       ];

FakeAnimals = ["betsy", "galaxy", "etc."];


@implementation PageForMakingReservations : CPObject
{
  CPArray customObjectsLoaded;
  PersistentStore persistentStore;

  CPView pageView;
  CPPanel procedureDragList;
  CPPanel animalDragList;
  CPPanel target;
  CoordinatorPMR coordinator;
  PageControllerPMR pageController;
  GroupingsControllerPMR groupingsController;
  ReservationDataControllerPMR reservationDataController;
  AnimalControllerPMR animalController;
  ProcedureControllerPMR procedureController;
}

- (void)instantiatePageInWindow: theWindow withOwner: owner
{
  customObjectsLoaded = [[CPArray alloc] init];

  persistentStore = [self loadGlobalPersistentStore];

  pageController = [self custom: [[PageControllerPMR alloc] init]];
  reservationDataController = [self custom: [[ReservationDataControllerPMR alloc] init]];
  groupingsController = [self custom: [[GroupingsControllerPMR alloc] init]];
  coordinator = [self custom: [[CoordinatorPMR alloc] init]];
  animalController = [self custom: [[AnimalInterfaceController alloc] init]];
  procedureController = [self custom: [[ProcedureInterfaceController alloc] init]];

  pageView = [self putPageViewOverWindow: theWindow];
  [self drawControlsOnPage: pageView andConnectTo: reservationDataController];

  target = [self placeAnimalAndProcedureTargetPanel];

  var procedureCollectionView = [self dropTargetForDragType: ProcedureDragType
                                                normalColor: ProcedureHintColor
                                                 hoverColor: ProcedureStrongHintColor
                                                 controller: procedureController
                                                   selector: @selector(selectProcedure:)
                                                startingAtX: FirstTargetX];


  var animalCollectionView = [self dropTargetForDragType: AnimalDragType
                                             normalColor: AnimalHintColor
                                              hoverColor: AnimalStrongHintColor
                                              controller: animalController
                                                selector: @selector(selectAnimal:)
                                             startingAtX: SecondTargetX];

  procedureDragList = [[DragListPMR alloc] initWithTitle: "Procedures"
                                                   atX: FarthestLeftWindowX
                                       backgroundColor: ProcedureHintColor
                                               content: FakeProcedures
                                                ofType: ProcedureDragType];

  animalDragList = [[DragListPMR alloc] initWithTitle: "Animals"
                                                atX: FarthestRightWindowX
                                    backgroundColor: AnimalHintColor
                                            content: FakeAnimals
                                             ofType: AnimalDragType];


  // Connect outlets

  pageController.pageView = pageView;
  pageController.target = target;
  pageController.animalDragList = animalDragList;
  pageController.procedureDragList = procedureDragList;

  groupingsController.procedureView = procedureCollectionView;
  groupingsController.animalView = animalCollectionView;
  groupingsController.redisplayView = [target contentView];

  coordinator.persistentStore = persistentStore;
  coordinator.reservationDataController = reservationDataController;
  coordinator.animalController = animalController;
  coordinator.procedureController = procedureController;
  coordinator.groupingsController = groupingsController;
  coordinator.pageController = pageController;
  

  owner.pmrPageController = pageController;
  
  [self awakenAllObjects];
}

- (PersistentStore) loadGlobalPersistentStore
{
  var persistentStore = [self custom: [[PersistentStore alloc] init]];
  persistentStore.network = [[NetworkConnection alloc] init];
  return persistentStore;
}



-(CPView) putPageViewOverWindow: window
{
  var containingView = [window contentView];
  var pageView = [[CPView alloc] initWithFrame: [containingView frame]];
  [containingView addSubview: pageView];
  return pageView;
}


-(id) drawControlsOnPage: pageView andConnectTo: reservationDataController
{  
  // TODO: get rid of at least some of thest manifest constants.

  var instructionLabel = [[CPTextField alloc] initWithFrame:CGRectMake(10, 30, 400, 30)];
  [instructionLabel setStringValue: "Fill in the information, then click the button."];
  [pageView addSubview: instructionLabel];


  var x = 10;
  var width = 45
  var courseLabel = [[CPTextField alloc] initWithFrame:CGRectMake(x, 75, width, 30)];
  [courseLabel setStringValue: "Course: "];
  [pageView addSubview:courseLabel];
  x += width;

  width = 100;
  var courseField = [[CPTextField alloc] initWithFrame:CGRectMake(x, 70, width, 30)];
  [courseField setEditable:YES];
  [courseField setBezeled:YES];
  [pageView addSubview:courseField];
  x+= width;

  x += 10;
  width = 90;
  var instructorLabel = [[CPTextField alloc] initWithFrame:CGRectMake(x, 75, width, 30)];
  [instructorLabel setStringValue: "Instructor NetID: "];
  [pageView addSubview:instructorLabel];
  x += width;

  width = 100;
  var instructorField = [[CPTextField alloc] initWithFrame:CGRectMake(x, 70, width, 30)];
  [instructorField setEditable:YES];
  [instructorField setBezeled:YES];
  [pageView addSubview:instructorField];
  x += width;

  x += 10;
  width = 20;
  var onLabel = [[CPTextField alloc] initWithFrame:CGRectMake(x, 75, width, 30)];
  [onLabel setStringValue: "on: "];
  [pageView addSubview:onLabel];
  x += width;

  width = 100;
  var dateField = [[CPTextField alloc] initWithFrame:CGRectMake(x, 70, width, 30)];
  [dateField setEditable:YES];
  [dateField setBezeled:YES];
  [dateField setStringValue: "2009-"];
  [pageView addSubview:dateField];
  x += width;

  x += 10;
  width = 90
  var morningButton = [[CPRadio alloc] initWithFrame: CGRectMake(x, 67, width, 20)];
  [morningButton setState:CPOnState];
  [morningButton setTitle:"morning"];
  
  var afternoonButton = [[CPRadio alloc] initWithFrame: CGRectMake(x, 87, width, 20) radioGroup:[morningButton radioGroup]];
  [afternoonButton setTitle:"afternoon"];

  [pageView addSubview: morningButton];
  [pageView addSubview: afternoonButton];
  x += width;
    
  x += 15;
  width = 80;
  var beginButton = [[CPButton alloc] initWithFrame:CGRectMake(x, 70, width, 30)];
  [beginButton setTitle: "Begin"];
  [pageView addSubview:beginButton];
  [beginButton setTarget: reservationDataController];
  [beginButton setAction: @selector(commitToParticularCourseSession:)];
  x += width;


  x += 15;
  var placeForLink = x;
  width = 80;
  var reserveButton = [[CPButton alloc] initWithFrame:CGRectMake(x, 70, width, 30)];
  [reserveButton setTitle: "Reserve"];
  [reserveButton setHidden: YES];
  [pageView addSubview:reserveButton];
  [reserveButton setTarget: reservationDataController];
  [reserveButton setAction: @selector(makeReservation:)];
  x += width;

  x += 15;
  width = 180;
  var restartButton = [[CPButton alloc] initWithFrame:CGRectMake(x, 70, width, 30)];
  [restartButton setTitle: "Restart (doesn't work yet)"];
  [restartButton setHidden: YES];
  [pageView addSubview:restartButton];
  [restartButton setTarget: reservationDataController];
  [restartButton setAction: @selector(abandonReservation:)];


  var webView = [[CPWebView alloc] initWithFrame: CGRectMake(placeForLink,60,500,100)];
  [webView setHidden: YES];
  [pageView addSubview: webView];

  reservationDataController.linkToPreviousResults = webView;
  reservationDataController.courseField = courseField;
  reservationDataController.instructorField = instructorField;
  reservationDataController.dateField = dateField;
  reservationDataController.morningButton = morningButton;
  reservationDataController.beginButton = beginButton;
  reservationDataController.reserveButton = reserveButton;
  reservationDataController.restartButton = restartButton;

  var newGroupButton = [[CPButton alloc] initWithFrame:CGRectMake(x, 70, width, 30)];
  [newGroupButton setTitle: "New Group (doesn't work yet)"];
  [newGroupButton setHidden: YES];
  [pageView addSubview:newGroupButton];
  // [restartButton setTarget: reservationDataController];
  // [restartButton setAction: @selector(abandonReservation:)];
  groupingsController.newGroupButton = newGroupButton;


  // Temporary for testing
  [instructorField setStringValue: "morin"];
  [courseField setStringValue: "VM333"];
  [dateField setStringValue: "2009-09-23"];

  // TODO: do this with notifications.
  // [pageController setDesiredFirstResponder:courseField];
  [courseField setNextKeyView: dateField];
  [dateField setNextKeyView: afternoonButton];

  // Doesn't work.
  //  [theWindow setDefaultButton: goButton];
  //  [theWindow enableKeyEquivalentForDefaultButton];
  [customObjectsLoaded addObject:reservationDataController];
  return reservationDataController;
}


-(CPPanel) placeAnimalAndProcedureTargetPanel
{
  var rect = CGRectMake(FirstGroupingWindowX, WindowTops, GroupingWindowWidth,
                        TargetWindowHeight);
  var target = [[CPPanel alloc] initWithContentRect: rect
                                          styleMask:CPHUDBackgroundWindowMask | CPResizableWindowMask];
  [target setLevel:CPFloatingWindowLevel];
  [target setTitle:@"Drag from left and right to group procedures with animals used for them"];
  return target;
}

- (CPCollectionView) dropTargetForDragType: dragType
                               normalColor: normalColor
                                hoverColor: hoverColor
                                controller: controller
                                  selector: selector
                               startingAtX: x
{
  var collectionView = [[CPCollectionView alloc] initWithFrame: CGRectMakeZero()];

  var dropTarget = [[DropTarget alloc] initWithFrame: CGRectMakeZero()];
  dropTarget.controller = controller;
  dropTarget.dropAction = selector;
  [dropTarget registerForDraggedTypes:[dragType]];
  [dropTarget setBackgroundColor: normalColor];
  dropTarget.subtleHint = normalColor;
  dropTarget.strongHint = hoverColor;
  dropTarget.dragType = dragType;

  [self arrangeDropTarget: dropTarget
        andCollectionView: collectionView
                    under: [target contentView]
              startingAtX: x];
  return collectionView;
}


-(id) arrangeDropTarget: dropTarget andCollectionView: collectionView under: contentView startingAtX: x
{
  [dropTarget setFrame: CGRectMake(x, 0, TargetWidth, TargetViewHeight)];
  [contentView addSubview:dropTarget];

  var scrollViewFrame = [dropTarget bounds];
  var scrollView = [[CPScrollView alloc] initWithFrame: scrollViewFrame];
  [dropTarget addSubview: scrollView];
        
  [scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
  [scrollView setAutohidesScrollers:YES];

  var collectionViewFrame = [[scrollView contentView] bounds];
  // collectionView = [[CPCollectionView alloc] initWithFrame: CGRectMakeZero()];
  //  collectionView = [[CPCollectionView alloc] initWithFrame: collectionViewFrame];
  [collectionView setFrame: collectionViewFrame];
  [collectionView setMinItemSize:CGSizeMake(TruncatedTextLineWidth, TextLineHeight)];
  [collectionView setMaxItemSize:CGSizeMake(TruncatedTextLineWidth, TextLineHeight)];
  [collectionView setDelegate:self];
  [scrollView setDocumentView:collectionView];


  var itemPrototype = [[CPCollectionViewItem alloc] init];
  [itemPrototype setView:[[DragListItemViewPMR alloc] initWithFrame:CGRectMakeZero()]];
        
  [collectionView setItemPrototype:itemPrototype];
  return dropTarget;
}

- (id) custom: anObject
{
  [customObjectsLoaded addObject:anObject];
  return anObject;
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

