@import <Critter4Us/view/DateTimeEditingControl.j>
@import "ScenarioTestCase.j"

@implementation DateTimeEditingControlTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[DateTimeEditingControl alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardOutlets: ['dateField', 'morningButton', 'afternoonButton']];
}

-(void) testCanBeSetToASpecificDateAndMorningValue
{
  [scenario
    previousAction: function() {
      [sut.dateField setStringValue: 'BOGUS'];
      [sut.morningButton setState: CPOffState];
      [sut.afternoonButton setState: CPOnState];
    }
    testAction: function() {
      [sut setDate: '2009-01-01' morningState: CPOnState]
    }
  andSo: function() {
      [self assert: '2009-01-01' equals: [sut.dateField stringValue]];
      [self assert: CPOnState equals: [sut.morningButton state]];
      [self assert: CPOffState equals: [sut.afternoonButton state]];
   }];
}

-(void) testTimeCanBeSetToAfternoon
{
  [scenario
    previousAction: function() {
      [sut.morningButton setState: CPOnState];
      [sut.afternoonButton setState: CPOffState];
    }
    testAction: function() {
      [sut setDate: '2009-01-01' morningState: CPOffState]
    }
  andSo: function() {
      [self assert: CPOffState equals: [sut.morningButton state]];
      [self assert: CPOnState equals: [sut.afternoonButton state]];
   }];
}

@end	
