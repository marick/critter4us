@import <Critter4Us/view/DropTarget.j>
@import "ScenarioTestCase.j"

@implementation DropTargetTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[DropTarget alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasDownwardCollaborators: ['controller']];
}

-(void) selectAnimal: aName
{
  [sut.targetView shouldReceive: @selector(droppedString)
                      andReturn: aName];
  [sut selectAnimal: sut.targetView];
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


@end
