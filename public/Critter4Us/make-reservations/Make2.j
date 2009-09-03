@import <Foundation/CPObject.j>
@import <AppKit/AppKit.j>
@import "../util/Constants.j"

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



@implementation Make2 : CPObject
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


@import <AppKit/CPPanel.j>


@implementation DragList : CPPanel
{
  CPArray content;
  CPDragType dragType;
}

- (id)initWithTitle: title atX: x backgroundColor: color content: someContent ofType: someDragType
{
  dragType = someDragType;
    self = [self initWithContentRect:CGRectMake(x, WindowTops, DragSourceWindowWidth, DragSourceWindowHeight) styleMask:CPHUDBackgroundWindowMask | CPResizableWindowMask];

    if (self)
    {
        [self setTitle:title];
        [self setFloatingPanel:YES];
        
        var contentView = [self contentView],
            bounds = [contentView bounds];
        
        bounds.size.height -= WindowBottomMargin;

        var collectionView = [[CPCollectionView alloc] initWithFrame:bounds];
        
        [collectionView setAutoresizingMask:CPViewWidthSizable];
        [collectionView setMinItemSize:CGSizeMake(CompleteTextLineWidth, TextLineHeight)];
        [collectionView setMaxItemSize:CGSizeMake(CompleteTextLineWidth, TextLineHeight)];
        [collectionView setDelegate:self];
        
        var itemPrototype = [[CPCollectionViewItem alloc] init];
        
        [itemPrototype setView:[[DragListItemView alloc] initWithFrame:CGRectMakeZero()]];
        
        [collectionView setItemPrototype:itemPrototype];
        
        var scrollView = [[CPScrollView alloc] initWithFrame:bounds];
        
        [scrollView setDocumentView:collectionView];
        [scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        [scrollView setAutohidesScrollers:YES];

        [[scrollView contentView] setBackgroundColor:color];

        [contentView addSubview:scrollView];
        
        content = someContent;
        [collectionView setContent:content];
    }

    return self;
}


- (CPData)collectionView:(CPCollectionView)aCollectionView dataForItemsAtIndexes:(CPIndexSet)indices forType:(CPString)aType
{
    return [CPKeyedArchiver archivedDataWithRootObject:[content objectAtIndex:[indices firstIndex]]];
}

- (CPArray)collectionView:(CPCollectionView)aCollectionView dragTypesForItemsAtIndexes:(CPIndexSet)indices
{
    return [dragType];
}

@end

@implementation DragListItemView : CPTextField
{
}

- (void)setSelected:(BOOL)isSelected
{
    [self setBackgroundColor:isSelected ? [CPColor grayColor] : nil];
}

- (void)setRepresentedObject:(id)anObject
{
  [self setStringValue: anObject];
}

@end



@import <AppKit/CPWindowController.j>
@import <AppKit/CPDragServer.j>

@implementation DropTarget : CPView
{
  id controller;
  SEL dropAction;
  CPColor subtleHint;
  CPColor strongHint;
  CPDragType dragType;
}

- (void) giveSubtleHint
{
  [self setBackgroundColor: subtleHint];
}

- (void) giveStrongHint
{
  [self setBackgroundColor: strongHint];
}


- (CPBoolean) prepareForDragOperation: (id) aSender
{
  return YES;
}

- (CPBoolean)performDragOperation:(CPDraggingInfo)aSender
{
  var value = [CPKeyedUnarchiver unarchiveObjectWithData:[[aSender draggingPasteboard] dataForType:dragType]];
  [controller performSelector: dropAction withObject: value];
  //  [controller newProcedure: value];
  return YES;
}

- (CPDragOperation)draggingEntered:(CPDraggingInfo)aSender
{
  [self giveStrongHint];
  // TODO: return value CPDragOperationCopy should have. Don't know why
  // definition is inaccessible. In current Cappuccino, value is ignored
  // anyway.
  return 1<<1;
}

- (void)draggingExited:(CPDraggingInfo)aSender
{
  [self giveSubtleHint];
}

- (void) concludeDragOperation: (id) aSender
{
  [self giveSubtleHint];
}
@end


@implementation GroupingController : CPWindowController
{
  CPWindow window;
  CPCollectionView procedureView;
  CPCollectionView animalView;
}

- (id)initWithWindow: theWindow
{
    self = [super initWithWindow:theWindow];
    window = [self window];
    
    return self;
}

- (void) alertWithRect: rect andTag: tag
{
  alert(tag + " at " + [[rect.origin.x, rect.origin.y, rect.size.height, rect.size.width] description]);
}


- (void) awakeFromCib
{
        [window setDelegate:self];
        
        var contentView = [window contentView];
        //        [self alertWithRect: dropTargetFrame andTag: "drop target"];
        // [contentView setBackgroundColor:[CPColor whiteColor]];

        procedureView = [[CPCollectionView alloc] initWithFrame: CGRectMakeZero()];
        [procedureView setContent: ['a sample procedure']];

        var procedureDropTarget = [[DropTarget alloc] initWithFrame: CGRectMakeZero()];
        procedureDropTarget.dropAction = @selector(addProcedure:);
        [procedureDropTarget registerForDraggedTypes:[ProcedureDragType]];
        [procedureDropTarget setBackgroundColor: ProcedureHintColor];
        procedureDropTarget.subtleHint = ProcedureHintColor;
        procedureDropTarget.strongHint = ProcedureStrongHintColor;
        procedureDropTarget.dragType = ProcedureDragType;

        [self arrangeDropTarget: procedureDropTarget
               andCollectionView: procedureView
                          under: contentView
                    startingAtX: FirstTargetX];


        animalView = [[CPCollectionView alloc] initWithFrame: CGRectMakeZero()];
        [animalView setContent: ['a sample animal']];

        var animalDropTarget = [[DropTarget alloc] initWithFrame: CGRectMakeZero()];
        animalDropTarget.dropAction = @selector(addAnimal:);
        [animalDropTarget registerForDraggedTypes:[AnimalDragType]];
        [animalDropTarget setBackgroundColor: AnimalHintColor];
        animalDropTarget.subtleHint = AnimalHintColor;
        animalDropTarget.strongHint = AnimalStrongHintColor;
        animalDropTarget.dragType = AnimalDragType;

        [self arrangeDropTarget: animalDropTarget
               andCollectionView: animalView
                          under: contentView
                    startingAtX: SecondTargetX];

}

-(id) arrangeDropTarget: dropTarget andCollectionView: collectionView under: contentView startingAtX: x
{
  [dropTarget setFrame: CGRectMake(x, 0, TargetWidth, TargetViewHeight)];
  dropTarget.controller = self;
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

-(void) addProcedure: aName
{
  //  alert("new procedure to add to " + [[procedureView content] description]);
  [procedureView setContent: [[procedureView content] arrayByAddingObject: aName]];
  [[window contentView] setNeedsDisplay: YES];
}

-(void) addAnimal: aName
{
  //  alert("new procedure to add to " + [[procedureView content] description]);
  [animalView setContent: [[animalView content] arrayByAddingObject: aName]];
  [[window contentView] setNeedsDisplay: YES];
}

@end
