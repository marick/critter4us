@import <AppKit/AppKit.j>

GlobalCheckboxTarget = "nothing yet";


@implementation CheckboxTableColumn : CPTableColumn
{
}

- (id) dataViewForRow: (CPInteger) row
{
  var retval = [[CritterCheckBox alloc] init];
  [retval setTarget: [[self dataCell] target]];
  [retval setAction: [[self dataCell] action]];
  retval.index = row;
  checked = [GlobalCheckboxTarget tableView: nil
	   objectValueForTableColumn: GlobalCheckboxTarget.checkColumn
	   row: row];
  if (checked) [retval setState: CPOnState];
  return retval;
}

@end

@implementation CritterCheckBox : CPCheckBox
{
  (CPInteger) index;
}

- (CPInteger) clickedRow
{
  return index;
}


// - (void)trackMouse:(CPEvent)anEvent
// {
//   [super trackMouse: anEvent];
//   if (CPLeftMouseUpMask & (1 << [anEvent type]))
//     {
      // [self sendAction: [self action] to: [self target]];
      // [GlobalCheckboxTarget toggleAnimal: self];
//    }
//}

- (void) encodeWithCoder: (CPCoder)aCoder
{
  [super encodeWithCoder:aCoder];
  [aCoder encodeObject: index forKey: @"critter row index"];
}

- (void) initWithCoder: (CPCoder)aCoder
{
  self = [super initWithCoder:aCoder];
  index = [aCoder decodeObjectForKey: @"critter row index"];
  [self setTarget: GlobalCheckboxTarget];
  return self;
}

- (CPString) description
{
  return [CPString stringWithFormat: "a %@ at row %d directed to %@/%@", [self class], index, [self target], [self action]];
}


@end
