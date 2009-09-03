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
