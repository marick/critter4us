@import <Critter4Us/util/Bugfixes.j>


@implementation SomeObject : CPObject
{
  id field;
}

- (id) initWithField: value
{
  if (self = [super init])
  {
    field = value;
  }
  return self;
}

- (BOOL) isEqual: (id)anObject
{
  return field === anObject.field;
}

- (unsigned) hash
{
  return [field hash];
}

@end

@implementation _BugfixesTest : OJTestCase
{
  CPSet set;
  SomeObject object;
  SomeObject differentButIsEqual;
  SomeObject completelyDifferent;
}


- (void) setUp
{
  set = [[CPSet alloc] init];
  object = [[SomeObject alloc] initWithField: "object"];
  differentButIsEqual = [[SomeObject alloc] initWithField: "object"];
  completelyDifferent = [[SomeObject alloc] initWithField: "completely different"];

  [set addObject: object];
}

- (void) test_that_identical_objects_are_counted_as_contained
{
  [self assertTrue: [set containsObject: object]];
}

- (void) test_that_content_equality_is_used_to_check_presence
{
  [self assertTrue: [set containsObject: differentButIsEqual]];
}

- (void) test_that_failure_can_be_due_to_different_contents
{
  [self assertFalse: [set containsObject: completelyDifferent]];
}

- (void) test_that_basic_types_work_as_expected
{
  [set addObjectsFromArray: [1, "string", ["string"]]]
  [self assertTrue: [set containsObject: 1]];
  [self assertTrue: [set containsObject: "string"]];
  [self assertTrue: [set containsObject: ["string"]]];
}

@end
