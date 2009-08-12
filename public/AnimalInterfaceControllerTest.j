@import "AnimalInterfaceController.j"
@import "ScenarioTestCase.j"

@implementation AnimalInterfaceControllerTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[AnimalInterfaceController alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardCollaborators: ['table', 'nameColumn',
					'checkColumn', 'containingView']];
  [scenario sutHasDownwardCollaborators: ['persistentStore']];
}


-(void) testInitialAppearance
{
  [scenario 
   beforeAwakening: function() {
      [self someAnimalsAreStored: [["cc", "B", "aaa"],
		      {"cc":"ckind","B":"bkind","aaa":"akind"}]];
    }
    whileAwakening: function() {
      [self tableWillLoadData];
      //
      [self controlsWillBeMadeHidden];
    }
    andTherefore: function() {
      [self animalTableWillContainNames: ["aaa (akind)", "B (bkind)", "cc (ckind)"]];
      [self animalTableWillHaveCorrespondingChecks: [NO, NO, NO]];
    }];
}


- (void)testChoosingACourseSession
{
  [scenario
   given: function() {
      [self someAnimalsAreStored];
    }
   during: function() {
      [self sendNotification: CourseSessionDescribedNews];
    }
  behold: function() {
      [self controlsWillBeMadeVisible];
    }
   ];
}

 
- (void)testExcludingAnimalsBecauseOfChosenProcedures
{
  [scenario
   given: function() { 
      [self someAnimalsAreStored: [["fred", "betty", "dave"],
                                  {"fred":"cow","betty":"irrelevant","dave":"horse"}]];
    }
   sequence: function() { 
	[self notifyOfExclusions: { 'veniculture': ['fred'],
                                    'physical exam': ['betty'],
                                     'floating':['dave']}];
	[self notifyOfChosenProcedures: ['veniculture', 'physical exam']];
    }
  means: function() {
      [self animalTableWillContainNames: ["dave (horse)"]];
      [self animalTableWillHaveCorrespondingChecks: [NO]];
    }];
}

- (void) testChoosingAnAnimal
{
  [scenario
   given: function() { 
      [self someAnimalsAreStored: [["alpha",  "delta", "betty"],
                                   {"alpha":"akind", "delta":"dkind", "betty":"bkind"}]
       ];
    }
  sequence: function() { 
      [self selectAnimal: "betty"];
    }
  means: function() {
      [self animalTableWillContainNames: ["alpha (akind)", "betty (bkind)", "delta (dkind)"]];
      [self animalTableWillHaveCorrespondingChecks: [NO, YES, NO]];
    }];
}

- (void) testChoosingTwoAnimalsAccumulates
{
  [scenario
   given: function() { 
      [self someAnimalsAreStored: [["alpha",  "delta", "betty"],
                                   {"alpha":"akind", "delta":"dkind", "betty":"bkind"}]];
      [self alreadySelected: ["betty"]];
    }
  sequence: function() { 
      [self selectAnimal: "alpha"];
    }
  means: function() {
      [self animalTableWillContainNames: ["alpha (akind)", "betty (bkind)", "delta (dkind)"]];
      [self animalTableWillHaveCorrespondingChecks: [YES, YES, NO]];
    }];
}


- (void) testChoosingAnimalsThenAProcedureThatExcludesOne
{
  [scenario
   given: function() { 
      [self someAnimalsAreStored: [["alpha",  "delta", "betty"],
                                   {"alpha":"akind", "delta":"dkind", "betty":"bkind"}]];
      [self usingExclusions: { 'veniculture': ['alpha'],
	                       'physical exam': ['betty'],
                               'floating':['delta']}];
      [self alreadySelected: ["betty", "delta"]];
    }
  sequence: function() { 
      [self animalTableWillContainNames: ["alpha (akind)", "betty (bkind)", "delta (dkind)"]];
      [self animalTableWillHaveCorrespondingChecks: [NO, YES, YES]];
      [self notifyOfChosenProcedures: ['veniculture', 'physical exam']];

    }
  means: function() {
      [self animalTableWillContainNames: ["delta (dkind)"]];
      [self animalTableWillHaveCorrespondingChecks: [YES]];
    }];
}

- (void) testSpillingData
{
  var dict = [CPMutableDictionary dictionary];
  [scenario
   given: function() { 
      [self someAnimalsAreStored: [["alpha",  "delta", "betty"],
                                   {"alpha":"akind", "delta":"dkind", "betty":"bkind"}]];
      [self alreadySelected: ["betty", "delta"]];
    }
  sequence: function() { 
      [sut spillIt: dict];

    }
  means: function() {
      [self assert: ["betty", "delta"]
            equals: [dict objectForKey: "animals"]];
    }];
}


-(void) selectAnimal: aName
{
  var index = [sut.availableAnimals indexOfObject: aName];
  [sut.table shouldReceive: @selector(clickedRow) andReturn: index];
  // Column is irrelevant - allow click on name OR check to count as check.
  [sut toggleAnimal: sut.table];
}


// This is a really a hack because there's no mechanism in the mocks
// to sequence two calls of the same method on the same object. At least,
// I think it's a hack.
-(void) alreadySelected: animalNames
{
  [sut awakeFromCib];
  for(i=0; i<[animalNames count]; i++)
    {
      var aName = animalNames[i];
      var index = [sut.availableAnimals indexOfObject: aName];
      [sut toggleAnimalAtIndex: index];
    }
}



-(void) someAnimalsAreStored: anArray
{
  [sut.persistentStore shouldReceive: @selector(allAnimalInfo) andReturn: anArray];
}

-(void) someAnimalsAreStored
{
  [self someAnimalsAreStored: [['betsy'], {'betsy' : 'bovine'}]];
}

-(void) tableWillLoadData
{
  [sut.table shouldReceive: @selector(reloadData)];
}

-(void) animalTableWillContainNames: anArray
{
  [self column: sut.nameColumn
        inTable: sut.table
        named: @"animal table name column"
        willContain: anArray];
}

-(void) animalTableWillHaveCorrespondingChecks: anArray
{
  [self column: sut.checkColumn
        inTable: sut.table
        named: @"animal table checkmarks column"
        willContain: anArray];
}

- (void) notifyOfExclusions: (id)aJSHash
{
  dict = [CPDictionary dictionaryWithJSObject: aJSHash recursively: YES];
  [self sendNotification:@"exclusions" withObject: dict];
}

- (void) usingExclusions: (id)aJSHash
{
  [sut awakeFromCib];
  [self notifyOfExclusions: aJSHash];
}


@end	
