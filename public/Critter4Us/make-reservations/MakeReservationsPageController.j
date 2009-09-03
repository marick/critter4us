@implementation MakeReservationsPageController : CPWindowController
{
  CPWindow window;
  CPCollectionView procedureView;
  CPCollectionView animalView;
}

- (id)initWithWindow: aWindow
{
    self = [super initWithWindow: aWindow];
    // The following automagically creates the window on screen by side effect.
    window = [self window]; 
    [window setDelegate:self];
    return self;
}

-(void) addProcedure: aName
{
  // alert("new procedure to add to " + [[procedureView content] description]);
  [procedureView setContent: [[procedureView content] arrayByAddingObject: aName]];
  [[window contentView] setNeedsDisplay: YES];
}

-(void) addAnimal: aName
{
  //  alert("new procedure to add to " + [[procedureView content] description]);
  [animalView setContent: [[animalView content] arrayByAddingObject: aName]];
  [[window contentView] setNeedsDisplay: YES];
}


// Util

- (void) alertWithRect: rect andTag: tag
{
  alert(tag + " at " + [[rect.origin.x, rect.origin.y, rect.size.height, rect.size.width] description]);
}


@end
