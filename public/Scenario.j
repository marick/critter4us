@implementation Scenario : CPObject
{
  OJTestCase test;
  id sut;
  CPArray collaboratorNames;

  Mock randomListener;
}

-(Scenario)initForTest: aTest andSut: aSut
{
  test = aTest;
  sut = aSut;
  collaboratorNames = [];
  randomListener = [[Mock alloc] initWithName: "any old listener"]
  return self;
}

-(void) given: given sequence: sequence means: consequence
{
  nothing = function() { }
  [self given: given during: sequence behold: nothing andTherefore: consequence];
}


-(void) during: during behold: behold 
{
  nothing = function() {}
  [self given: nothing during: during behold: behold andTherefore: nothing];
}

-(void) given: given during: during behold: behold andTherefore: result
{
  given();
  if (! sut.awakened) [sut awakeFromCib];
  behold();
  during();
  [self checkAllExpectations];
  result();
}




-(void) beforeAwakening: setup whileAwakening: (id)mockSettings andTherefore: (id)result
{
  setup();
  [self whileAwakening: mockSettings andTherefore: result];
}

-(void) whileAwakening: (id)mockSettings andTherefore: (id)result
{
  mockSettings();
  [test.sut awakeFromCib];
  [self checkAllExpectations];
  result();
}


- (void)checkAllExpectations
{
  for(i=0; i<[collaboratorNames count]; i++)
    {
      var name = [collaboratorNames objectAtIndex: i];
      [test assertTrue: [sut[name] wereExpectationsFulfilled]];
    }
  [randomListener wereExpectationsFulfilled];
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

