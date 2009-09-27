@import <Critter4Us/view/DateTimeEditingControl.j>
@import "ScenarioTestCase.j"

@implementation DateTimeEditingControlTest : ScenarioTestCase
{
  
}

- (void)setUp
{
  sut = [[DateTimeEditingControl alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasDownwardOutlets: ['target']];

  [CPApplication sharedApplication]; // clicks only work in this context.
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


-(void) testTargetWillBeInformedOfCancel
{
  [scenario
    during: function() {
      [sut setTarget: sut.target];
      [sut.cancelButton performClick: UnusedArgument]
    }
  behold: function() {
      sut.target.failOnUnexpectedSelector = YES;
      [sut.target shouldReceive: @selector(forgetEditingDateTime:)
                           with: sut];
   }];
}


-(void) testTargetWillBeInformedOfAcceptedChange
{
  [scenario
    during: function() {
      [sut setTarget: sut.target];
      [sut.changeButton performClick: UnusedArgument]
    }
  behold: function() {
      [sut.target shouldReceive: @selector(newDateTimeValuesReady:)
                           with: sut];
   }];
}


-(void) testCanRetrieveDateAndMorningState
{
  [sut setDate: '2009-01-01' morningState: CPOnState];
  [self assert: '2009-01-01' equals: [sut date]];
  [self assert: CPOnState equals: [sut morningState]];
}

@end	
