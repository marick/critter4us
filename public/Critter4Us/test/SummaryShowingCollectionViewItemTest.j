@import <Critter4Us/view/SummaryShowingCollectionViewItem.j>
@import "ScenarioTestCase.j"


@implementation SummaryShowingCollectionViewItemTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[SummaryShowingCollectionViewItem alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardCollaborators: ['view']];
}

- (void)testSetRepresentedObjectPresentsSummaryToViewer
{
  var summaryProtocolObject = [[Mock alloc] initWithName: "represented object"];
  [scenario 
    during: function() { 
      [sut setRepresentedObject: summaryProtocolObject];
    }
  behold: function() {
      [summaryProtocolObject shouldReceive: @selector(summary)
                                 andReturn: "some summary"];
      [sut.view shouldReceive: @selector(setStringValue:)
                         with: 'some summary'];
    }];
}

- (void)testSetRepresentedObjectDoesNotOverwriteExistingEntry
{
  var summaryProtocolObject = [[Mock alloc] initWithName: "represented object"];
  [scenario 
    during: function() { 
      [sut setRepresentedObject: summaryProtocolObject];
    }
  behold: function() {
      [summaryProtocolObject shouldReceive: @selector(summary)
                                 andReturn: "some summary"];
      [sut.view shouldReceive: @selector(setStringValue:)
                         with: 'some summary'];
    }];

  [summaryProtocolObject clear];

  [scenario
     during: function() {
      summaryProtocolObject.failOnUnexpectedSelector = YES;
      [sut setRepresentedObject: summaryProtocolObject];
    }
  behold: function() {
      // There should be no calls.
    }];
}

@end
