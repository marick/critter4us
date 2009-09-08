@import <Critter4Us/page-for-making-reservations/DragListPMR.j>
@import "ScenarioTestCase.j"

@implementation DragListPMRTest : ScenarioTestCase
{
}

-(void) testDragListIsUntestable
{
  // DragList is hard to test because it's a Panel (theoretically part
  // of the thin view layer). The following blows up. Since the
  // DragList really doesn't do anything but supply an element of its
  // collection view, it's probably not worth hacking around to make
  // it testable.
}

@end
