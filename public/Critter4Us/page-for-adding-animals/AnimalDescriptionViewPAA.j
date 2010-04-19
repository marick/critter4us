@import <AppKit/AppKit.j>
@import "../view/CritterPopUpButton.j"
@import "../util/AnimalDescription.j"


@implementation AnimalDescriptionViewPAA : CPView
{
  CPTextField nameField;
  CritterPopUpButton speciesPopUp;
  CPTextField noteField;
}

- (void) setPossibleSpecies: list selecting: favorite
{
  [speciesPopUp addItemsWithTitles: list];
  [speciesPopUp selectItemWithTitle: favorite];
}

- (void) setNote: note
{
  [noteField setStringValue: note];
}

- (void) setSpecies: name
{
  [speciesPopUp selectItemWithTitle: name];
}

- (AnimalDescription) animalDescription
{
  var retval = [[AnimalDescription alloc] initWithName: [nameField stringValue]
					       species: [speciesPopUp selectedItemTitle]
						  note: [noteField stringValue]];
  return retval;
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
  speciesPopUp = [[CritterPopUpButton alloc] initWithFrame: CGRectMake(x, y+3, width, height)];
  [self addSubview: speciesPopUp];

  x += width + 10;
  width = 200;
  noteField = [[CPTextField alloc] initWithFrame: CGRectMake(x, y, width, height)];
  [noteField setEditable: YES];
  [noteField setBezeled: YES];
  [self addSubview: noteField];

  [noteField setDelegate: self];
  return self;
}

@end
