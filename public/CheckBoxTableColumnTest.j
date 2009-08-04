@import "CheckboxHacks.j"

@implementation CheckBoxTableColumnTest : OJTestCase
{
}

-(void) testColumnProducesDataViewsContainingRowNumber
{
  var column = [[CheckboxTableColumn alloc] initWithIdentifier: "foo!"];
  CPLog([column description]);
  CPLog([column dataViewForRow: 3]);
  [self assert: 3
   equals: [column dataViewForRow: 3].index];
}

@end
