@import <AppKit/AppKit.j>
@import "../util/Constants.j"
@import "Constants.j"
@import "DragList.j"
@import "../view/DropTarget.j"
@import "MakeReservationsPageController.j"

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


@implementation NewMakeReservationsCib : CPObject
{
  CPPanel procedureDragList;
  CPPanel animalDragList;
  CPPanel target;
  MakeReservationsPageController pageController;
}

- (void)instantiatePageInWindow: theWindow withOwner: owner
{
  var contentView = [theWindow contentView];

  target = [self placeAnimalAndProcedureTargetPanel];

  pageController = [[MakeReservationsPageController alloc] initWithWindow:target];
  [pageController showWindow: self];


  var procedureView = [self dropTargetForDragType: ProcedureDragType
                                      normalColor: ProcedureHintColor
                                       hoverColor: ProcedureStrongHintColor
                                       controller: pageController
                                         selector: @selector(addProcedure:) // TODO replce with notifications
                                      startingAtX: FirstTargetX];
  pageController.procedureView = procedureView;


  var animalView = [self dropTargetForDragType: AnimalDragType
                                   normalColor: AnimalHintColor
                                    hoverColor: AnimalStrongHintColor
                                    controller: pageController
                                      selector: @selector(addAnimal:) // TODO replce with notifications
                                   startingAtX: SecondTargetX];
  pageController.animalView = animalView;

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
  owner.newMakeReservationPageController = self;
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


-(void) appear // TODO: move
{
  [procedureDragList orderFront: self];
  [animalDragList orderFront: self];
  [target orderFront: self];
}

-(void) disappear // TODO: move to window controller
{
  [procedureDragList orderOut: self];
  [animalDragList orderOut: self];
  [target orderOut: self];
}

@end

