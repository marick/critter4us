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

-(void) testCanBeSetToASpecificDateAndTime
{
  [scenario
    previousAction: function() {
      [sut.dateField setStringValue: 'BOGUS'];
      [sut.morningButton setState: CPOffState];
      [sut.afternoonButton setState: CPOnState];
      [sut.eveningButton setState: CPOffState];
    }
    testAction: function() {
      [sut setDate: '2009-01-01' time: [Time morning]]
    }
  andSo: function() {
      [self assert: '2009-01-01' equals: [sut.dateField stringValue]];
      [self assert: CPOnState equals: [sut.morningButton state]];
      [self assert: CPOffState equals: [sut.afternoonButton state]];
      [self assert: CPOffState equals: [sut.eveningButton state]];
   }];
}

-(void) testTimeCanBeSetToEvening
{
  [scenario
    previousAction: function() {
      [sut.morningButton setState: CPOnState];
      [sut.afternoonButton setState: CPOffState];
      [sut.eveningButton setState: CPOffState];
    }
    testAction: function() {
      [sut setDate: '2009-01-01' time: [Time evening]]
    }
  andSo: function() {
      [self assert: CPOffState equals: [sut.morningButton state]];
      [self assert: CPOffState equals: [sut.afternoonButton state]];
      [self assert: CPOnState equals: [sut.eveningButton state]];
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


-(void) testCanRetrieveDateAndTime
{
  [sut setDate: '2009-01-01' time: [Time morning]];
  [self assert: '2009-01-01' equals: [sut date]];
  [self assert: [Time morning] equals: [sut time]];

  [sut setDate: '2009-02-02' time: [Time afternoon]];
  [self assert: '2009-02-02' equals: [sut date]];
  [self assert: [Time afternoon] equals: [sut time]];

  [sut setDate: '2009-01-01' time: [Time evening]];
  [self assert: '2009-01-01' equals: [sut date]];
  [self assert: [Time evening] equals: [sut time]];
}

@end	
