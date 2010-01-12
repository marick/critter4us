@import <Critter4Us/util/CheckboxHacks.j>

@implementation _CritterCheckBoxTest : OJTestCase
{
}

-(void) testArchivingPreservesIndex
{
  box = [[CritterCheckBox alloc] init];
  box.index = 3;
  var archive = [CPKeyedArchiver archivedDataWithRootObject: box];
  newBox = [CPKeyedUnarchiver unarchiveObjectWithData: archive];

  [self assert: box.index equals: newBox.index];
}

-(void) testArchivingPreservesActionButNotTarget
{
  box = [[CritterCheckBox alloc] init];
  [box setTarget: @"target"];
  [box setAction: @selector(foo:)];
  var archive = [CPKeyedArchiver archivedDataWithRootObject: box];
  newBox = [CPKeyedUnarchiver unarchiveObjectWithData: archive];

  [self assert: [box action] equals: [newBox action]];
  [self assertFalse: [[box target] isEqual: [newBox target]]];
}

-(void) testArchivingPreservesState
{
  box = [[CritterCheckBox alloc] init];
  [self assert: CPOffState equals: [box state]];
  [box setState: CPOnState];
   
  var archive = [CPKeyedArchiver archivedDataWithRootObject: box];
  newBox = [CPKeyedUnarchiver unarchiveObjectWithData: archive];

  [self assert: [box state] equals: [newBox state]];
}

@end
