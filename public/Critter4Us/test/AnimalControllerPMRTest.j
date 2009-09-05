@import <Critter4Us/page-for-making-reservations/AnimalControllerPMR.j>
@import <Critter4Us/util/Time.j>
@import "ScenarioTestCase.j"

@implementation AnimalControllerPMRTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[AnimalControllerPMR alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardCollaborators: ['sourceView', 'targetView']]
}

// Let's assume the only way to push data into the views is via
// pushDisplay.  This is how it works. Tests of relevant methods only
// check for its effects once.
-(void) testPushingDataAlwaysRefreshes
{
  [scenario 
    previousAction: function() {
      [sut beginUsingAnimals: [] withKindMap: {}];
    }
  during: function() {
      [sut pushDisplay];
    }
  behold: function() {
      [sut.sourceView shouldReceive: @selector(setNeedsDisplay:)
                               with: YES];
      [sut.targetView shouldReceive: @selector(setNeedsDisplay:)
                               with: YES];
    }];
}

-(void) testBeginning
{
  [scenario 
    during: function() {
      [sut beginUsingAnimals: ["cc", "B", "aaa"]
                 withKindMap: {"cc":"ckind","B":"bkind","aaa":"akind"}]
       }
    behold: function() {
      [sut.sourceView shouldReceive: @selector(setContent:)
                               with: [["aaa (akind)", "B (bkind)", "cc (ckind)"]]];
      [sut.targetView shouldReceive: @selector(setContent:)
                               with: [[]]];
    }];
}

- (void) testAnimalsCanBePutInUseImmediately
{
  [scenario 
    during: function() {
      [sut beginUsingAnimals: ["cc", "B", "aaa"]
                 withKindMap: {"cc":"ckind","B":"bkind","aaa":"akind"}
                   andChoose: ['cc', 'aaa']];
       }
    behold: function() { 
      [sut.sourceView shouldReceive: @selector(setContent:)
                               with: [["aaa (akind)", "B (bkind)", "cc (ckind)"]]];
      [sut.targetView shouldReceive: @selector(setContent:)
                               with: [["aaa (akind)", "cc (ckind)"]]];
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
      [sut.sourceView shouldReceive: @selector(setContent:)
                               with: [["dave (horse)"]]];
      [sut.targetView shouldReceive: @selector(setContent:)
                               with: [[]]];

      [sut.sourceView shouldReceive: @selector(setNeedsDisplay:)
                               with: YES];
      [sut.targetView shouldReceive: @selector(setNeedsDisplay:)
                               with: YES];
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
  during: function() {
      [sut withholdAnimals: []]
    }
  behold: function() {
      [sut.sourceView shouldReceive: @selector(setContent:)
                               with: [["betty (cow)", "dave (horse)", "fred (cow)"]]];
      [sut.targetView shouldReceive: @selector(setContent:)
                               with: [[]]];
    }];
}


- (void) testChoosingAnAnimalCopiesItsNameIntoTheTarget
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
      // Source view does not change.
      [sut.targetView shouldReceive: @selector(setContent:)
                               with: [["betty (bkind)"]]];

      [sut.targetView shouldReceive: @selector(setNeedsDisplay:)
                               with: YES];
    }];
}

- (void) testChoosingAnimalsAccumulates
{
  [scenario
   previousAction: function() { 
      [sut beginUsingAnimals: ["alpha",  "delta", "betty"]
                 withKindMap: {"alpha":"akind", "delta":"dkind", "betty":"bkind"}
                   andChoose: ['betty']];
    }
  during: function() { 
      [self selectAnimal: "alpha"];
    }
  behold: function() { 
      [sut.targetView shouldReceive: @selector(setContent:)
                               with: [["alpha (akind)", "betty (bkind)"]]];
    }];
}


- (void) testWithholdingAnimalsChangesBothViews
{
  [scenario
  previousAction: function() {
      [sut beginUsingAnimals: ["alpha",  "delta", "betty"]
                 withKindMap: {"alpha":"akind", "delta":"dkind", "betty":"bkind"}
                   andChoose: ['betty', 'delta']];
    }
  during: function() { 
      [sut withholdAnimals: ['alpha', 'betty']];
    }
  behold: function() {
      [sut.sourceView shouldReceive: @selector(setContent:)
                               with: [["delta (dkind)"]]];
      [sut.targetView shouldReceive: @selector(setContent:)
                               with: [["delta (dkind)"]]];
    }];
}

- (void) testWithholdingThenAllowingAnAnimalDoesNOTPutItBackInUsedAnimalList
{
  [scenario
    previousAction: function() {
      [sut beginUsingAnimals: ["alpha",  "delta", "betty"]
                 withKindMap: {"alpha":"akind", "delta":"dkind", "betty":"bkind"}
                   andChoose: ["betty", "delta"]];

      [sut withholdAnimals: ['betty']];
    }
  testAction: function() { 
      [sut withholdAnimals: []];
    }
  andSo: function() {
      [sut.sourceView shouldReceive: @selector(setContent:)
                               with: [["alpha (akind)", "betty (bkind)", "delta (dkind)"]]];
      [sut.targetView shouldReceive: @selector(setContent:)
                               with: [["delta (dkind)"]]];
    }];
}

-(void) testBeginningAgain
{
  [scenario 
    previousAction: function() {
      [sut beginUsingAnimals: ["cc", "B", "aaa"]
                 withKindMap: {"cc":"ckind","B":"bkind","aaa":"akind"}
                   andChoose: ["cc"]];
      [sut withholdAnimals: ['B']];
    }
  during: function() {
      [sut beginUsingAnimals: ["cc", "B", "aaa"]
                 withKindMap: {"cc":"ckind","B":"bkind","aaa":"akind"}];
    }
  behold: function() { 
      [sut.sourceView shouldReceive: @selector(setContent:)
                               with: [["aaa (akind)", "B (bkind)", "cc (ckind)"]]];
      [sut.targetView shouldReceive: @selector(setContent:)
                               with: [[]]];
    }];
}


- (void) testSpillingData
{
  var dict = [CPMutableDictionary dictionary];
  [scenario
  previousAction: function() {
      [sut beginUsingAnimals: ["alpha",  "delta", "betty"]
                 withKindMap: {"alpha":"akind", "delta":"dkind", "betty":"bkind"}
                   andChoose: ["betty", "delta"]];
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
  [sut.targetView shouldReceive: @selector(droppedString)
                      andReturn: aName];
  [sut selectAnimal: sut.targetView];
}

-(void) DRAGselectAnimal: aName
{
  dataglob = [CPKeyedArchiver archivedDataWithRootObject: aName];
  pasteboard = [[Mock alloc] initWithName: "pasteboard"];
  [pasteboard shouldReceive: @selector(dataForType:)
                  andReturn: dataglob];
  fakeDragSource = [[Mock alloc] initWithName: "drag source"];
  [fakeDragSource shouldReceive: @selector(draggingPasteboard)
                      andReturn: pasteboard];

  [sut.targetView draggingEntered: fakeDragSource];
  [sut.targetView prepareForDragOperation: fakeDragSource];
  [sut.targetView performDragOperation: fakeDragSource];
}

@end	
