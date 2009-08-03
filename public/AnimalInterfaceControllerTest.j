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
      [self animals: ["Betical", "order", "alpha"]];
    }
    whileAwakening: function() {
      [self tableWillLoadData];
      //
      [self controlsWillBeMadeHidden];
    }
    andTherefore: function() {
      [self animalTableWillContainNames: ["alpha", "Betical", "order"]];
      [self animalTableWillHaveCorrespondingChecks: [NO, NO, NO]];
    }];
}


- (void)testChoosingADate
{
  [scenario 
   during: function() {
      [self sendNotification: "date chosen"];
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
      [self animals: ["fred", "betty", "dave"]];
    }
   sequence: function() { 
	[self notifyOfExclusions: { 'veniculture': ['fred'],
                                    'physical exam': ['betty'],
                                     'floating':['dave']}];
	[self notifyOfChosenProcedures: ['veniculture', 'physical exam']];
    }
  means: function() {
      [self animalTableWillContainNames: ["dave"]];
      [self animalTableWillHaveCorrespondingChecks: [NO]];
    }];
}



-(void) animals: anArray
{
  [sut.persistentStore shouldReceive: @selector(allAnimalNames) andReturn: anArray];
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


- (void) notifyOfChosenProcedures: (CPArray)anArray
{
  [self sendNotification: @"procedures chosen" withObject: anArray];
}

@end	
