@import <Critter4Us/view/GroupCollectionView.j>
@import "ScenarioTestCase.j"

@implementation GroupCollectionViewTest : ScenarioTestCase
{
  GroupCollectionView sut;
  
  NamedObject someNamedObject;
  NamedObject anotherNamedObject;
  NamedObject unnamedObject;
}

- (void) setUp
{
  sut = [[GroupCollectionView alloc] initWithFrame: CGRectMakeZero()];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  // [scenario sutHasDownwardCollaborators: ['delegate']];

  someNamedObject = [[NamedObject alloc] initWithName: 'some named object'];
  anotherNamedObject = [[NamedObject alloc] initWithName: 'another named object'];
  unnamedObject = [[NamedObject alloc] initWithName: ''];
}

- (void) testCollectionIsInitiallyEmpty
{
  [self assert: [] equals: [sut content]];
  [self assertTrue: -1 == [sut.currentIndex]];
}

- (void) testCollectionCanBecomeEmptyAgain
{
  [sut addNamedObjectToContent: someNamedObject];
  [sut becomeEmpty];
  [self assert: [] equals: [sut content]];
  [self assertTrue: -1 == [sut.currentIndex]];
}

- (void) testCanAddContent
{
  [sut addNamedObjectToContent: someNamedObject];
  [self assert: [someNamedObject] equals: [sut content]];
  [sut addNamedObjectToContent: anotherNamedObject];
  [self assert: [someNamedObject, anotherNamedObject] equals: [sut content]];
}

- (void) testAddingMakesANewArrayDoesNotReuseOldOne
{
  // CPCollectionViews don't consider adding an element to existing
  // content to be a change, so modifying and setting a copy is appropriate.
  var original = [sut content];
  [sut addNamedObjectToContent: someNamedObject];
  [self assertFalse: [sut content] == original];
}

- (void) testAnAddedElementBecomesTheCurrentOne
{
  [sut addNamedObjectToContent: someNamedObject];
  [self assert: someNamedObject equals: [sut currentRepresentedObject]];
  [sut addNamedObjectToContent: anotherNamedObject];
  [self assert: anotherNamedObject equals: [sut currentRepresentedObject]];
}

- (void) testButtonTitleIsObjectName
{
  [sut setContent: [someNamedObject]];
  [self assert: [someNamedObject name]
        equals: [self titleForItem: 0]];
}

- (void) test_butAnEmptyNameCanBeReplacedWithSomethingDescriptive
{
  [sut setDefaultName: 'default'];
  [sut setContent: [unnamedObject]];
  [self assert: "default"
        equals: [self titleForItem: 0]];
}

- (void) test_theItemCanBeToldToRefreshItsTitle
{
  [sut addNamedObjectToContent: unnamedObject];
  [unnamedObject setName: 'new name'];
  [sut currentNameHasChanged];
  [self assert: 'new name'
        equals: [self titleForItem: 0]];
}


// util

- (CPString) titleForItem: index
{
  return [[self buttonAt: index] title];
}

- (CPBoolean) isHighlighted: index
{
  
  var button = [self buttonAt: index];
  return [[button themeState] isEqual: CPThemeStateDefault];
}

- (CPString) buttonAt: index
{
  var item = [[sut items] objectAtIndex: index];
  return [item view];
}


@end
