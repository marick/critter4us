@implementation Scenario : CPObject
{
  OJTestCase test;
}

-(Scenario)initForTest: aTest
{
  test = aTest;
  return self;
}

-(void) given: setup during: andThen behold: behold
{
  setup();
  andThen();
  behold();
}

-(void) given: setup whileAwakening: (id)mockSettings
{
  setup();
  mockSettings();
  [test.sut awakeFromCib];
}
@end

