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
}


-(void) testBeginning
{
  [scenario 
    during: function() {
      [sut beginUsingAnimals: ["cc", "B", "aaa"]
                 withKindMap: {"cc":"ckind","B":"bkind","aaa":"akind"}]
       }
    behold: function() { 
      [sut.table shouldReceive: @selector(reloadData)];
    }
    andSo: function() {
	[self animalTableWillContainNames: ["aaa (akind)", "B (bkind)", "cc (ckind)"]];
	[self animalTableWillHaveCorrespondingChecks: [NO, NO, NO]];
    }];
}

- (void) testAnimalsCanBePutInUseImmediately
{
  [scenario 
    during: function() {
      [sut beginUsingAnimals: ["cc", "B", "aaa"]
             withAlreadyUsed: ['cc', 'aaa']
                 withKindMap: {"cc":"ckind","B":"bkind","aaa":"akind"}]
       }
    behold: function() { 
      [sut.table shouldReceive: @selector(reloadData)];
    }
    andSo: function() {
	[self animalTableWillContainNames: ["aaa (akind)", "B (bkind)", "cc (ckind)"]];
	[self animalTableWillHaveCorrespondingChecks: [YES, NO, YES]];
    }];
}

-(void) testBeginningAgain
{
  [scenario 
    previousAction: function() {
      [sut beginUsingAnimals: ["cc", "B", "aaa"]
                 withKindMap: {"cc":"ckind","B":"bkind","aaa":"akind"}];
      [self selectAnimal: "cc"];
      [sut withholdAnimals: ['B']];
      [self animalTableWillContainNames: ["aaa (akind)", "cc (ckind)"]];
      [self animalTableWillHaveCorrespondingChecks: [NO, YES]];
    }
  during: function() {
      [sut beginUsingAnimals: ["cc", "B", "aaa"]
                 withKindMap: {"cc":"ckind","B":"bkind","aaa":"akind"}];
    }
  behold: function() { 
      [sut.table shouldReceive: @selector(reloadData)];
    }
  andSo: function() {
      [self animalTableWillContainNames: ["aaa (akind)", "B (bkind)", "cc (ckind)"]];
      [self animalTableWillHaveCorrespondingChecks: [NO, NO, NO]];
    }];
}


- (void)testWithholdingAnimals
{
  [scenario
   previousAction: function() { 
      [sut beginUsingAnimals: ["fred", "betty", "dave"]
                 withKindMap: {"fred":"cow","betty":"irrelevant","dave":"horse"}];
    }
  during: function() { 
      [sut withholdAnimals: ['fred', 'betty']];
    }
  behold: function() {
      [sut.table shouldReceive: @selector(reloadData)];
    }
  andSo: function() {
      [self animalTableWillContainNames: ["dave (horse)"]];
      [self animalTableWillHaveCorrespondingChecks: [NO]];
    }];
}

- (void)testWithholdingAnimalsNeedNotBePermanent
{
  [scenario
   previousAction: function() { 
      [sut beginUsingAnimals: ["fred", "betty", "dave"]
                 withKindMap: {"fred":"cow","betty":"cow","dave":"horse"}];
      [sut withholdAnimals: ['fred', 'betty']];
    }
  testAction: function() { 
      [sut withholdAnimals: []]
    }
  andSo: function() {
      [self animalTableWillContainNames: ["betty (cow)", "dave (horse)", "fred (cow)"]];
      [self animalTableWillHaveCorrespondingChecks: [NO, NO, NO]];
    }];
}


- (void) testChoosingAnAnimal
{
  [scenario
   previousAction: function() { 
      [sut beginUsingAnimals: ["alpha",  "delta", "betty"]
                 withKindMap: {"alpha":"akind", "delta":"dkind", "betty":"bkind"}];
    }
  during: function() { 
      [self selectAnimal: "betty"];
    }
  behold: function() {
      [sut.table shouldReceive: @selector(deselectAll:)];
      [sut.table shouldReceive: @selector(reloadData)];
    }
  andSo: function() {
      [self animalTableWillContainNames: ["alpha (akind)", "betty (bkind)", "delta (dkind)"]];
      [self animalTableWillHaveCorrespondingChecks: [NO, YES, NO]];
    }];
}

- (void) testChoosingAnimalsAccumulates
{
  [scenario
   previousAction: function() { 
      [sut beginUsingAnimals: ["alpha",  "delta", "betty"]
                 withKindMap: {"alpha":"akind", "delta":"dkind", "betty":"bkind"}];
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


- (void) testChoosingAnimalsThenWithholdingOneOfThem
{
  [scenario
  previousAction: function() {
      [sut beginUsingAnimals: ["alpha",  "delta", "betty"]
                 withKindMap: {"alpha":"akind", "delta":"dkind", "betty":"bkind"}];

      [self alreadySelected: ["betty", "delta"]];
      [self animalTableWillContainNames: ["alpha (akind)", "betty (bkind)", "delta (dkind)"]];
      [self animalTableWillHaveCorrespondingChecks: [NO, YES, YES]];
    }
  testAction: function() { 
      [sut withholdAnimals: ['alpha', 'betty']];
    }
  andSo: function() {
      [self animalTableWillContainNames: ["delta (dkind)"]];
      [self animalTableWillHaveCorrespondingChecks: [YES]];
    }];
}

- (void) testWithholdingAnAnimalErasesItsCheckmarkIfItReappears
{
  [scenario
  previousAction: function() {
      [sut beginUsingAnimals: ["alpha",  "delta", "betty"]
                 withKindMap: {"alpha":"akind", "delta":"dkind", "betty":"bkind"}];

      [self alreadySelected: ["betty", "delta"]];
      [sut withholdAnimals: ['betty']];
      [self animalTableWillContainNames: ["alpha (akind)", "delta (dkind)"]];
      [self animalTableWillHaveCorrespondingChecks: [NO, YES]];
    }
  testAction: function() { 
      [sut withholdAnimals: []];
    }
  andSo: function() {
      [self animalTableWillContainNames: ["alpha (akind)", "betty (bkind)", "delta (dkind)"]];
       [self animalTableWillHaveCorrespondingChecks: [NO, NO, YES]];
    }];
}


- (void) testSpillingData
{
  var dict = [CPMutableDictionary dictionary];
  [scenario
  previousAction: function() {
      [sut beginUsingAnimals: ["alpha",  "delta", "betty"]
                 withKindMap: {"alpha":"akind", "delta":"dkind", "betty":"bkind"}];
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
  for(i=0; i<[animalNames count]; i++)
    {
      var aName = animalNames[i];
      var index = [sut.availableAnimals indexOfObject: aName];
      [sut toggleAnimalAtIndex: index];
    }
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
