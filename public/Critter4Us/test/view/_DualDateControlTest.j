@import <Critter4Us/view/DualDateControl.j>

@implementation _DualDateControlTest : OJTestCase
{
  DualDateControl sut;
}

- (void) setUp
{
  sut = [[DualDateControl alloc] initAtX: 0 y: 0];
}

- (void) test_can_set_date_fields
{
  [sut setFirst: '2010-01-01' last: '2010-02-02'];
  [self assert: '2010-01-01' equals: [sut.firstDateField stringValue]];
  [self assert: '2010-02-02' equals: [sut.lastDateField stringValue]];
}

- (void) test_can_return_date_fields
{
  [sut setFirst: '2010-01-01' last: '2010-02-02'];
  [self assert: '2010-01-01' equals: [sut firstDate]];
  [self assert: '2010-02-02' equals: [sut lastDate]];
}

- (void) test_by_default_editing_first_date_updates_last_date_with_same_value
{
  [sut setFirst: '2010-01-01' last: '2010-02-02'];

  [sut.firstDateField setStringValue: "2111-12-12"]; // pretend edited value.
  [sut controlTextDidChange: [CPNotification notificationWithName: CPControlTextDidChangeNotification
							       object: sut.firstDateField]];

  [self assert: '2111-12-12' equals: [sut firstDate]];
  [self assert: '2111-12-12' equals: [sut lastDate]];
}


- (void) test_by__editing_first_date_does_not_affect_last_date_that_has_been_edited
{
  [sut.lastDateField setStringValue: "2222-12-12"]; // pretend edited value.
  [sut controlTextDidChange: [CPNotification notificationWithName: CPControlTextDidChangeNotification
							       object: sut.lastDateField]];
 
  [sut.firstDateField setStringValue: "1111-11-11"]; // pretend edited value.
  [sut controlTextDidChange: [CPNotification notificationWithName: CPControlTextDidChangeNotification
							       object: sut.firstDateField]];

  [self assert: '1111-11-11' equals: [sut firstDate]];
  [self assert: '2222-12-12' equals: [sut lastDate]];
}



@end
