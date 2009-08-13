@import "AnimalInterfaceController.j"
@import "ScenarioTestCase.j"
@import "Time.j"

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
   beforeApp: function() {
      [self someAnimalsAreStored: [["cc", "B", "aaa"],
		      {"cc":"ckind","B":"bkind","aaa":"akind"}]];
    }
    whileAwakening: function() {
      [self tableWillLoadData];
      //
      [self controlsWillBeMadeHidden];
    }
    andSo: function() {
      [self animalTableWillContainNames: ["aaa (akind)", "B (bkind)", "cc (ckind)"]];
      [self animalTableWillHaveCorrespondingChecks: [NO, NO, NO]];
    }];
}



-(void) testWhatItMeansToLoadExclusions
{
  [scenario
   beforeApp: function() {
      [self someAnimalsAreStored];
    }
   during: function() {
      [sut loadExclusionsForDate: '2009-08-12' time: [Time afternoon]];
    }
  behold: function() {
      [sut.persistentStore shouldReceive: @selector(exclusionsForDate:time:)
       with: ['2009-08-12', [Time afternoon]]];
    }
   ];
}
 

- (void)testExcludingAnimalsBecauseOfChosenProcedures
{
  [scenario
   beforeApp: function() { 
      [self someAnimalsAreStored: [["fred", "betty", "dave"],
                                  {"fred":"cow","betty":"irrelevant","dave":"horse"}]];
      [self someExclusionsApply: { 'veniculture': ['fred'],
                                    'physical exam': ['betty'],
                                     'floating':['dave']}];
    }
  previousAction: function() {
      [sut loadExclusionsForDate: '2009-08-12' time: [Time afternoon]];
    }
  testAction: function() { 
      [sut offerAnimalsForProcedures: ['veniculture', 'physical exam']];
    }
  andSo: function() {
      [self animalTableWillContainNames: ["dave (horse)"]];
      [self animalTableWillHaveCorrespondingChecks: [NO]];
    }];
}

- (void) testChoosingAnAnimal
{
  [scenario
   beforeApp: function() { 
      [self someAnimalsAreStored: [["alpha",  "delta", "betty"],
                                   {"alpha":"akind", "delta":"dkind", "betty":"bkind"}]
       ];
    }
  testAction: function() { 
      [self selectAnimal: "betty"];
    }
  andSo: function() {
      [self animalTableWillContainNames: ["alpha (akind)", "betty (bkind)", "delta (dkind)"]];
      [self animalTableWillHaveCorrespondingChecks: [NO, YES, NO]];
    }];
}

- (void) testChoosingTwoAnimalsAccumulates
{
  [scenario
   beforeApp: function() { 
      [self someAnimalsAreStored: [["alpha",  "delta", "betty"],
                                   {"alpha":"akind", "delta":"dkind", "betty":"bkind"}]];
    }
  previousAction: function() {
      [self alreadySelected: ["betty"]];
    }
  testAction: function() { 
      [self selectAnimal: "alpha"];
    }
  andSo: function() {
      [self animalTableWillContainNames: ["alpha (akind)", "betty (bkind)", "delta (dkind)"]];
      [self animalTableWillHaveCorrespondingChecks: [YES, YES, NO]];
    }];
}


- (void) testChoosingAnimalsThenAProcedureThatExcludesOne
{
  [scenario
   beforeApp: function() { 
      [self someAnimalsAreStored: [["alpha",  "delta", "betty"],
                                   {"alpha":"akind", "delta":"dkind", "betty":"bkind"}]];
      [self someExclusionsApply: { 'veniculture': ['alpha'],
	                           'physical exam': ['betty'],
                                   'floating':['delta']}];
    }
  previousAction: function() {
      [sut loadExclusionsForDate: '2009-08-12' time: [Time afternoon]];
      [self alreadySelected: ["betty", "delta"]];
      [self animalTableWillContainNames: ["alpha (akind)", "betty (bkind)", "delta (dkind)"]];
      [self animalTableWillHaveCorrespondingChecks: [NO, YES, YES]];
    }
  testAction: function() { 
      [sut offerAnimalsForProcedures: ['veniculture', 'physical exam']];

    }
  andSo: function() {
      [self animalTableWillContainNames: ["delta (dkind)"]];
      [self animalTableWillHaveCorrespondingChecks: [YES]];
    }];
}

- (void) testSpillingData
{
  var dict = [CPMutableDictionary dictionary];
  [scenario
   beforeApp: function() { 
      [self someAnimalsAreStored: [["alpha",  "delta", "betty"],
                                   {"alpha":"akind", "delta":"dkind", "betty":"bkind"}]];
    }
  previousAction: function() {
      [self alreadySelected: ["betty", "delta"]];
    }
  testAction: function() { 
      [sut spillIt: dict];

    }
  andSo: function() {
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

-(void) someExclusionsApply: jsHash
{
  retval = [CPDictionary dictionaryWithJSObject: jsHash recursively: YES];
  [sut.persistentStore shouldReceive: @selector(exclusionsForDate:time:)
   andReturn: retval];
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



@end	
