@import <AppKit/AppKit.j>
@import "../util/Constants.j"
@import "Constants.j"
@import "DragList.j"
@import "../view/DropTarget.j"
@import "PMRPageController.j"
@import "PMRGroupingsController.j"
@import "ReservationDataController.j"

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

  CPView pageView;
  CPPanel procedureDragList;
  CPPanel animalDragList;
  CPPanel target;
  PMRPageController pageController;
  PMRGroupingsController groupingsController;
}

- (void)instantiatePageInWindow: theWindow withOwner: owner
{
  customObjectsLoaded = [[CPArray alloc] init];

  pageController = [self custom: [[PMRPageController alloc] init]];
  groupingsController = [self custom: [[PMRGroupingsController alloc] init]];

  pageView = [self putPageViewOverWindow: theWindow];
  [self drawControlsOnPageView];

  target = [self placeAnimalAndProcedureTargetPanel];

  var procedureCollectionView = [self dropTargetForDragType: ProcedureDragType
                                                normalColor: ProcedureHintColor
                                                 hoverColor: ProcedureStrongHintColor
                                                 controller: groupingsController
                                                   selector: @selector(addProcedure:) // TODO replce with notifications
                                                startingAtX: FirstTargetX];


  var animalCollectionView = [self dropTargetForDragType: AnimalDragType
                                             normalColor: AnimalHintColor
                                              hoverColor: AnimalStrongHintColor
                                              controller: pageController
                                                selector: @selector(addAnimal:) // TODO replce with notifications
                                             startingAtX: SecondTargetX];

  procedureDragList = [[DragList alloc] initWithTitle: "Procedures"
                                                   atX: FarthestLeftWindowX
                                       backgroundColor: ProcedureHintColor
                                               content: FakeProcedures
                                                ofType: ProcedureDragType];

  animalDragList = [[DragList alloc] initWithTitle: "Animals"
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

  owner.pmrPageController = pageController;
  
  [self awakenAllObjects];
}



-(CPView) putPageViewOverWindow: window
{
  var containingView = [window contentView];
  var pageView = [[CPView alloc] initWithFrame: [containingView frame]];
  [containingView addSubview: pageView];
  return pageView;
}


-(id) drawControlsOnPageView
{  
  // TODO: get rid of at least some of thest manifest constants.
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

  var reservationDataController = [[ReservationDataController alloc] init];
  reservationDataController.courseField = courseField;
  reservationDataController.instructorField = instructorField;
  reservationDataController.dateField = dateField;
  reservationDataController.morningButton = morningButton;
  reservationDataController.summaryField = summaryField;
  reservationDataController.buildingView = buildingView;
  reservationDataController.finishedView = finishedView;

  [goButton setTarget: reservationDataController];
  [goButton setAction: @selector(sessionReady:)];

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
  [itemPrototype setView:[[DragListItemView alloc] initWithFrame:CGRectMakeZero()]];
        
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

