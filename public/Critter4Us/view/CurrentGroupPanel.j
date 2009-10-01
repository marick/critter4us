@implementation CurrentGroupPanel : CPPanel
{
  CPCollectionView procedureCollectionView;
  CPCollectionView animalCollectionView;
}

- (void) init
{
  var rect = CGRectMake(FirstGroupingWindowX, WindowTops, GroupingWindowWidth,
                        TargetWindowHeight);
  self = [super initWithContentRect: rect
                          styleMask:CPHUDBackgroundWindowMask];
  [self setLevel:CPFloatingWindowLevel];
  [self setTitle:@"A group of procedures and the animals they will be performed on"];
  [self orderFront: self]; // TODO: delete when page layout done.

  [self addCollectionsViews];
  return self;
}


- (void) addCollectionsViews
{
  // Procedure half
  procedureCollectionView = [[NamedObjectCollectionView alloc]
                              initWithFrame: CGRectMakeZero()];
  [procedureCollectionView placeWithin: [self contentView]
                              withRect: CGRectMake(FirstTargetX, 0, TargetWidth, TargetViewHeight)
                   withBackgroundColor: ProcedureHintColor];
        
  // Animal half
  animalCollectionView = [[NamedObjectCollectionView alloc]
                              initWithFrame: CGRectMakeZero()];
  [animalCollectionView placeWithin: [self contentView]
                           withRect: CGRectMake(SecondTargetX, 0, TargetWidth, TargetViewHeight)
                withBackgroundColor: AnimalHintColor];
}

@end
