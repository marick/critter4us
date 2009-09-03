@import <AppKit/AppKit.j>
@import "../util/Constants.j"
@import "../view/DragList.j"
@import "../view/DropTarget.j"
@import "MakeReservationsPageController.j"

ProcedureHintColor = [CPColor colorWithRed: 0.8 green: 1.0 blue: 0.8 alpha: 1.0];
ProcedureStrongHintColor = [CPColor colorWithRed: 0.4 green: 1.0 blue: 0.4 alpha: 1.0];
AnimalHintColor = [CPColor colorWithRed: 1.0 green: 0.8 blue: 0.8 alpha: 1.0];
AnimalStrongHintColor = [CPColor colorWithRed: 1.0 green: 0.4 blue: 0.4 alpha: 1.0];

WindowBottomMargin = 20;
ScrollbarWidth = 20;
TextLineHeight = 20;

FarthestLeftWindowX = 10;
WindowTops = 200;

CompleteTextLineWidth = 250-ScrollbarWidth;
TruncatedTextLineWidth = 200;
DragSourceNumberOfLines = 15;
// TODO: Not actually right, since TextLineHeight doesn't include interspacing.
DragSourceWindowHeight = DragSourceNumberOfLines * TextLineHeight;
DragSourceWindowWidth = CompleteTextLineWidth + ScrollbarWidth;

FirstGroupingWindowX = FarthestLeftWindowX + DragSourceWindowWidth + 20;
GroupingWindowVerticalMargin = 10 ;
TargetWidth = TruncatedTextLineWidth;
GroupingWindowWidth = TargetWidth * 2 + GroupingWindowVerticalMargin * 3;
TargetNumberOfLines = 10; // Ditto TODO above
TargetViewHeight = TargetNumberOfLines * TextLineHeight;
TargetWindowHeight = TargetViewHeight + WindowBottomMargin;
FirstTargetX = GroupingWindowVerticalMargin
SecondTargetX = FirstTargetX + TargetWidth + GroupingWindowVerticalMargin

FarthestRightWindowX = FirstGroupingWindowX + GroupingWindowWidth + 20


@implementation NewMakeReservationsCib : CPObject
{
  CPPanel procedureDragList;
  CPPanel animalDragList;
  CPPanel target;
  
}

- (void)instantiatePageInWindow: theWindow withOwner: owner
{
  var contentView = [theWindow contentView];

  target = [[CPPanel alloc] initWithContentRect:CGRectMake(FirstGroupingWindowX, WindowTops, GroupingWindowWidth, TargetWindowHeight) styleMask:CPHUDBackgroundWindowMask | CPResizableWindowMask];
  [target setTitle:@"Drag from left and right to group procedures with animals used for them"];
  [target setLevel:CPFloatingWindowLevel];

  var groupingController = [[GroupingController alloc] initWithWindow:target];
  [groupingController showWindow: self];

  var procedures = [ @"castration",
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

  var animals = ["betsy", "galaxy", "etc."];

  procedureDragList = [[DragList alloc] initWithTitle: "Procedures"
                                                   atX: FarthestLeftWindowX
                                       backgroundColor: ProcedureHintColor
                                               content: procedures
                                                ofType: ProcedureDragType];

  animalDragList = [[DragList alloc] initWithTitle: "Animals"
                                                atX: FarthestRightWindowX
                                    backgroundColor: AnimalHintColor
                                            content: animals
                                             ofType: AnimalDragType];
  [groupingController awakeFromCib];

  owner.newMakeReservationPageController = self;
}

-(void) appear
{
  [procedureDragList orderFront: self];
  [animalDragList orderFront: self];
  [target orderFront: self];
}

-(void) disappear
{
  [procedureDragList orderOut: self];
  [animalDragList orderOut: self];
  [target orderOut: self];
}

@end

