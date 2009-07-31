@implementation Scenario : CPObject
{
  OJTestCase test;
  id sut;
  CPArray collaboratorNames;
}

-(Scenario)initForTest: aTest andSut: aSut
{
  test = aTest;
  sut = aSut;
  collaboratorNames = [];
  return self;
}

-(void) given: setup during: during behold: behold
{
  setup();
  [sut awakeFromCib];
  behold();
  during();
}

-(void) given: setup whileAwakening: (id)mockSettings
{
  setup();
  mockSettings();
  [test.sut awakeFromCib];
}


- (void)checkExpectations
{
  for(i=0; i<[collaboratorNames count]; i++)
    {
      var name = [collaboratorNames objectAtIndex: i];
      [test assertTrue: [sut[name] wereExpectationsFulfilled]];
    }
}

- (void)sutHasUpwardCollaborators: anArray
{
  [self sutHasCollaborators: anArray];
}

- (void)sutHasDownwardCollaborators: anArray
{
  [self sutHasCollaborators: anArray];
}

- (void)sutHasCollaborators: anArray
{
  for(i=0; i<[anArray count]; i++)
    {
      var name = [anArray objectAtIndex: i];
      [collaboratorNames addObject: name];
      var mock = [[Mock alloc] initWithName: name];
      mock.failOnUnexpectedSelector = NO;
      sut[name] = mock;
    }
}


@end

