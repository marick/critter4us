@import <AppKit/AppKit.j>

@implementation AnimalDescriptionViewPAA : CPView
{
  CPView container;
  CPTextField nameField;
  CPPopUpButton speciesPopUp;
  CPTextField noteField;
}

// These violate
- (void) setPossibleSpecies: list selecting: favorite
{
  [speciesPopUp addItemsWithTitles: list];
  [speciesPopUp selectItemWithTitle: favorite];
}

- (void) setNote: note
{
  [noteField setStringValue: note];
}


- (id) initAtX: x y: y
{
  self = [super initWithFrame: CGRectMake(x, y, 600, 100)];

  // [self setBackgroundColor: [CPColor redColor]];

  x = 0; 
  y = 0;
  var width = 200;
  var height = 30;
  nameField = [[CPTextField alloc] initWithFrame: CGRectMake(x, y, width, height)];
  [nameField setEditable: YES];
  [nameField setBezeled: YES];
  [nameField setHidden: NO];
  [self addSubview: nameField];
  
  x += width + 10;
  width = 100;
  speciesPopUp = [[CPPopUpButton alloc] initWithFrame: CGRectMake(x, y+3, width, height)];
  [speciesPopUp addItemWithTitle: "bovine"];
  [speciesPopUp addItemWithTitle: "caprine"];
  [speciesPopUp addItemWithTitle: "equine"];
  [self addSubview: speciesPopUp];

  x += width + 10;
  width = 200;
  noteField = [[CPTextField alloc] initWithFrame: CGRectMake(x, y, width, height)];
  [noteField setEditable: YES];
  [noteField setBezeled: YES];
  [noteField setStringValue: "cow"];
  [self addSubview: noteField];

  return self;
}

@end
