@import <Critter4Us/view/NamedObjectCollectionView.j>

@implementation NamedObjectCollectionViewTest : OJTestCase
{
  NamedObjectCollectionView sut;
}

- (void) setUp
{
  sut = [[NamedObjectCollectionView alloc] initWithFrame: CGRectMakeZero()];
}

- (void) testThatContentsAreSortedByCaseInsensitiveName
{
  detsy = [[NamedObject alloc] initWithName: 'detsy'];
  aaab = [[NamedObject alloc] initWithName: 'aaab'];
  cetsy = [[NamedObject alloc] initWithName: 'cetsy'];
  Abnot = [[NamedObject alloc] initWithName: 'Abnot']
  aaaa = [[NamedObject alloc] initWithName: 'aaaa'];

  [sut setContent: [detsy, aaab, cetsy, Abnot, aaaa]];

  [self assert: [aaaa, aaab, Abnot, cetsy, detsy]
        equals: [sut content]];
}

@end
