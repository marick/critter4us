@import <Critter4Us/view/NamedObjectCollectionView.j>
@import <Critter4Us/test/testutil/ScenarioTestCase.j>

@implementation NamedObjectCollectionViewTest : ScenarioTestCase
{
  NamedObjectCollectionView sut;
  NamedObject detsy, aaab, cetsy, Abnot, aaaa;

}

- (void) setUp
{
  sut = [[NamedObjectCollectionView alloc] initWithFrame: CGRectMakeZero()];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasDownwardCollaborators: ['delegate']];

  detsy = [[NamedObject alloc] initWithName: 'detsy'];
  aaab = [[NamedObject alloc] initWithName: 'aaab'];
  cetsy = [[NamedObject alloc] initWithName: 'cetsy'];
  Abnot = [[NamedObject alloc] initWithName: 'Abnot']
  aaaa = [[NamedObject alloc] initWithName: 'aaaa'];
}

- (void) testThatContentsAreSortedByCaseInsensitiveName
{

  [sut setContent: [detsy, aaab, cetsy, Abnot, aaaa]];

  [self assert: [aaaa, aaab, Abnot, cetsy, detsy]
        equals: [sut content]];
}


- (void) testAddContentAddsInCaseInsensitiveNameOrder
{

  [sut setContent: [detsy, aaab, cetsy]];
  [sut addContent: [Abnot, aaaa]];
  [self assert: [aaaa, aaab, Abnot, cetsy, detsy]
        equals: [sut content]];
}

- (void) testSelectingRemovesElementsAndSoInformsDelegate
{
  var selected = [CPMutableIndexSet indexSet];
  [selected addIndex: 1];
  [selected addIndex: 3];

  [scenario
    previously: function() {
      [sut setDelegate: sut.delegate]; // Because diff. conventions for names of instances in AppKit.
      [sut setContent: [aaaa, aaab, Abnot, cetsy, detsy]];
    }
    during: function() { 
      [sut setSelectionIndexes: selected];
    }
  behold: function() {
      [sut.delegate shouldReceive: @selector(objectsRemoved:fromList:)
                             with: [[aaab, cetsy]], sut];
    }
  andSo: function() {
      [self assert: [aaaa, Abnot, detsy]
            equals: [sut content]];
    }];
}

@end
