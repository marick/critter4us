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
      [self animals: ["one", "two"]];
    }
    whileAwakening: function() {
      [self tableWillLoadData];
      //
      [self tablesWillBeMadeHidden];
    }
    andTherefore: function() {
	[self animalTableWillContainNames: ["one", "two"]];
	[self animalTableWillHaveCorrespondingChecks: [NO, NO]];
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

@end	
