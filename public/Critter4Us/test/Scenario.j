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
  result = 'a value that indicates the result was not set';
  return self;
}

   // Having to do with awakeFromNib

-(void) whileAwakening: mockSettings
{
  [self beforeApp: Skip
    whileAwakening: mockSettings
            andSo: Skip];
        
}

-(void) afterAwakening: consequence
{
  [self beforeApp: Skip
    whileAwakening: Skip
            andSo: consequence];
        
}

-(void)       beforeApp: beforeApp
         whileAwakening: mockSettings
	          andSo: consequence
{
  beforeApp();
  mockSettings();
  [test.sut awakeFromCib];
  [self checkAllExpectations];
  [self removeAllExpectations];
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





- (void)checkAllExpectations
{
  //  CPLog('collaborators ' + [collaboratorNames description]);
  for(var i=0; i<[collaboratorNames count]; i++)
    {
      var name = [collaboratorNames objectAtIndex: i];
      // CPLog("working on collaborator " + name + "/" + sut[name]);
      var mock = sut[name];
      if ([mock respondsToSelector: @selector(wereExpectationsFulfilled)])
        // CPLog("... checking expectations");
        [test assertTrue: [mock wereExpectationsFulfilled]];
    }
  [randomListener wereExpectationsFulfilled];
}

- (void)removeAllExpectations
{
  for(var i=0; i<[collaboratorNames count]; i++)
    {
      var name = [collaboratorNames objectAtIndex: i];
      [sut[name] clear];
    }
  [randomListener clear];
}


- (void)sutHasUpwardCollaborators: anArray // TODO: Old name
{
  [self sutHasOutlets: anArray];
}

- (void)sutHasDownwardCollaborators: anArray // TODO: Old name
{
  [self sutHasOutlets: anArray];
}

- (void)sutHasUpwardOutlets: anArray
{
  [self sutHasOutlets: anArray];
}

- (void)sutHasDownwardOutlets: anArray
{
  [self sutHasOutlets: anArray];
}

- (void)sutHasOutlets: anArray
{
  for(i=0; i<[anArray count]; i++)
    {
      var name = [anArray objectAtIndex: i];
      [self makeOneMock: name];
    }
}



- (void) sutCreates: anArray
{
  [self sutHasOutlets: anArray];
}

- (Mock) makeOneMock: name
{
  [collaboratorNames addObject: name];
  var mock = [[Mock alloc] initWithName: name];
  mock.failOnUnexpectedSelector = NO;
  sut[name] = mock;
  return mock;
}


- (void) overrideAllocatedHelpers: anArray
{
  [self sutHasOutlets: anArray];
}


@end

