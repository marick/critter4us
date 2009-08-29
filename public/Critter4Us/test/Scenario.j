var Skip = function() {}


@implementation Scenario : CPObject
{
  OJTestCase test;
  id sut;
  CPArray collaboratorNames;
  id result;

  Mock randomListener;
}

-(Scenario)initForTest: aTest andSut: aSut
{
  test = aTest;
  sut = aSut;
  collaboratorNames = [];
  randomListener = [[Mock alloc] initWithName: "any old listener"];
  return self;
}

// NEW FAVORED NAMES

   // Having to do with awakeFromNib

-(void)       beforeApp: beforeApp
         whileAwakening: mockSettings
	          andSo: consequence
{
  beforeApp();
  mockSettings();
  [test.sut awakeFromCib];
  [self checkAllExpectations];
  consequence();
}

   // Having to do with rest of app


-(void)    beforeApp: beforeApp        // most specific version
      previousAction: previousAction
          testAction: testAction
              behold: behold 
               andSo: consequence
{
  beforeApp();
  if (! sut.awakened) [sut awakeFromCib];
  previousAction();
  behold();
  result = testAction();
  [self checkAllExpectations];
  consequence();
}

// synonym
-(void)    beforeApp: beforeApp        // most specific version
      previousAction: previousAction
          during: testAction
              behold: behold 
               andSo: consequence
{
  [self      beforeApp: beforeApp
        previousAction: previousAction
            testAction: testAction
		behold: behold
    	         andSo: consequence];
}



                                      // 4 keywords


-(void)     beforeApp: beforeApp
       previousAction: previousAction
           testAction: testAction
	        andSo: consequence
{
  [self      beforeApp: beforeApp
        previousAction: previousAction
            testAction: testAction
		behold: Skip
    	         andSo: consequence];
}

-(void)      beforeApp: beforeApp
        previousAction: previousAction
                during: testAction
	        behold: behold
{
  [self      beforeApp: beforeApp
        previousAction: previousAction
            testAction: testAction
		behold: behold
    	         andSo: Skip];
}

-(void)      beforeApp: beforeApp
                during: testAction
	        behold: behold
  		 andSo: consequence
{
  [self      beforeApp: beforeApp
        previousAction: Skip
                during: testAction
		behold: behold
    	         andSo: consequence];
}

-(void) previousAction: previousAction
                during: testAction
	        behold: behold
  		 andSo: consequence
{
  [self      beforeApp: Skip
        previousAction: previousAction
                during: testAction
		behold: behold
    	         andSo: consequence];
}

                                      // 3 keywords



-(void)     beforeApp: beforeApp
               during: during
	       behold: behold 
{
  [self       beforeApp: beforeApp
         previousAction: Skip
             testAction: during
	         behold: behold
          	  andSo: Skip];
}

-(void)previousAction: previousAction
               during: during
	       behold: behold 
{
  [self       beforeApp: Skip
         previousAction: previousAction
             testAction: during
	         behold: behold
          	  andSo: Skip];
}

-(void)  previousAction: previousAction
             testAction: during
	          andSo: consequence
{
  [self       beforeApp: Skip
         previousAction: previousAction
             testAction: during
	         behold: Skip
          	  andSo: consequence];
}

-(void)     beforeApp: beforeApp
           testAction: during
	        andSo: consequence
{
  [self       beforeApp: beforeApp
         previousAction: Skip
             testAction: during
	         behold: Skip
          	  andSo: consequence];
}

-(void)        during: during
	       behold: behold
	        andSo: consequence 
{
  [self       beforeApp: Skip
         previousAction: Skip
             testAction: during
	         behold: behold
          	  andSo: consequence];
}

                                      // 2 keywords

-(void)          during: during
                 behold: behold 
{
  [self       beforeApp: Skip
         previousAction: Skip
                 during: during
		 behold: behold
	          andSo: Skip];
}


-(void)          testAction: during
                      andSo: consequence
{
  [self       beforeApp: Skip
         previousAction: Skip
                 during: during
		 behold: Skip
	          andSo: consequence];
}


// OLD FAVORED NAMES






-(void) sequence: sequence means: consequence
{
  given = nothing = function() { }
  [self given: given during: sequence behold: nothing andTherefore: consequence];
}

-(void) given: given sequence: sequence means: consequence
{
  nothing = function() { }
  [self given: given during: sequence behold: nothing andTherefore: consequence];
}

-(void) given: given after: during behold: behold
{
  nothing = function() { }
  [self given: given during: during behold: behold andTherefore: nothing];
}



-(void) given: given during: during behold: behold 
{
  nothing = function() {}
  [self given: given during: during behold: behold andTherefore: nothing];
}

-(void) given: given during: during behold: behold andTherefore: consequence
{
  given();
  if (! sut.awakened) [sut awakeFromCib];
  behold();
  result = during();
  [self checkAllExpectations];
  consequence();
}




-(void) beforeAwakening: setup whileAwakening: (id)mockSettings andTherefore: (id)consequence
{
  setup();
  [self whileAwakening: mockSettings andTherefore: consequence];
}

-(void) whileAwakening: (id)mockSettings andTherefore: (id)consequence
{
  mockSettings();
  [test.sut awakeFromCib];
  [self checkAllExpectations];
  consequence();
}

-(void) whileAwakening: (id)mockSettings
{
  [self whileAwakening: mockSettings andTherefore:  function(){}];
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

