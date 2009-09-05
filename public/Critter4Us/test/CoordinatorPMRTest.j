@import <Critter4Us/page-for-making-reservations/CoordinatorPMR.j>
@import "ScenarioTestCase.j"

@implementation Spiller : Mock
{
  (CPDictionary) internal;
}

- (void) initWithValue: aValue
{
  self = [super init];
  internal =[CPDictionary dictionaryWithJSObject: aValue];
  failOnUnexpectedSelector = NO;
  return self;
}

- (void) spillIt: (CPMutableDictionary) dest
{
  var keys = [internal allKeys];
  for (var i=0; i < [keys count]; i++)
    {
      var key = [keys objectAtIndex: i];
      [dest setValue: [internal valueForKey: key] forKey: key];
    }
}

- (BOOL) wereExpectationsFulfilled
{
  return YES;
}

@end

@implementation CoordinatorPMRTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[CoordinatorPMR alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardCollaborators: ['reservationDataController', 'animalController', 'procedureController', 'groupingsController', 'pageController']];
  [scenario sutHasDownwardCollaborators: ['persistentStore']];
}

-(void) testInitialBehavior
{
  [scenario
   whileAwakening: function() {
      [sut.reservationDataController shouldReceive: @selector(allowUserToChooseParticularCourseSession)];
      [sut.groupingController shouldReceive: @selector(hideOnPageControls)];
      [sut.pageController shouldReceive: @selector(hideFloatingWindows)];
      [sut.pageController shouldReceive: @selector(setDisplayFloatingWindowsOnPageReveal:)
                                   with:NO];
    }];
}

-(void) testChangesDisplayWhenCourseSessionIsIdentified
{
  [scenario
   during: function() {
      [self sendNotification: ReservationDataCollectedNews];
    }
   behold: function() {
      [sut.groupingsController shouldReceive: @selector(showOnPageControls)];
      [sut.reservationDataController shouldReceive: @selector(freezeCourseSessionInput)];
      [sut.pageController shouldReceive: @selector(showFloatingWindows)];
      [sut.pageController shouldReceive: @selector(setDisplayFloatingWindowsOnPageReveal:)
                                   with:YES];
    }];
}

-(void) testHandsControllersValuableDataWhenCourseSessionIsIdentified
{
  [scenario
   previousAction: function() {
      sut.persistentStore.allAnimalNames = ['animal1', 'animal2'];
      sut.persistentStore.allProcedureNames = ['procedure1', 'procedure2'];
      sut.persistentStore.kindMap = {'animal1':'cow', 'animal2':'horse'};
      sut.reservationDataController =
          [[Spiller alloc] initWithValue: {'date':'2009-02-02',
	                                   'time':[Time morning]}];
    }
   during: function() {
      [self sendNotification: ReservationDataCollectedNews];
    }
   behold: function() {
      [sut.persistentStore shouldReceive: @selector(focusOnDate:time:)
                                    with: ['2009-02-02', [Time morning]]];
      [sut.animalController shouldReceive: @selector(beginUsingAnimals:withKindMap:)
                                     with: [sut.persistentStore.allAnimalNames, sut.persistentStore.kindMap]];
      [sut.procedureController shouldReceive: @selector(beginUsingProcedures:)
       with: [sut.persistentStore.allProcedureNames]];
    }];
}

- (void) testAdjustAnimalControllerAnimalsWhenProceduresChosenAreUpdated
{
  [scenario
   previousAction: function() {
      sut.persistentStore.allAnimalNames = ['animal1', 'animal2'];
      sut.persistentStore.exclusions = [CPDictionary dictionaryWithJSObject:{ 'a': ['animal1'], 'b':[] }];
    }
   during: function() {
      [self sendNotification: ProcedureChangeNews
       withObject: ["a", "b"]];
    }
   behold: function() {
      [sut.animalController shouldReceive: @selector(withholdAnimals:)
       with: [["animal1"]]];
    }];
}


- (void) testWithheldAnimalListDoesNotContainDuplicates
{
  [scenario
   previousAction: function() {
      sut.persistentStore.allAnimalNames = ['animal1', 'animal2', 'animal3'];
      sut.persistentStore.exclusions = [CPDictionary dictionaryWithJSObject:{ 'a': ['animal1'], 'b':['animal1','animal3'] }];
    }
   during: function() {
      [self sendNotification: ProcedureChangeNews
       withObject: ["a", "b"]];
    }
   behold: function() {
      [sut.animalController shouldReceive: @selector(withholdAnimals:)
       with: [["animal1", "animal3"]]];
    }];
}


-(void) testCollectsReservationDataAndSendsToPersistentStore
{
  [scenario
   previousAction: function() { 
      sut.reservationDataController = 
          [[Spiller alloc] initWithValue: {'date':'2009-03-05',
	                                   'time':[Time afternoon],
					   'course':'vm333',
					   'instructor':'fred'}];
      sut.groupingsController = 
    	  [[Spiller alloc] initWithValue: {'procedures':['procedure 1','procedure 2'],
                                           'animals':['animal 1', 'animal 2']}];
    }
   during: function() {
      [self sendNotification: GroupingsDataCollectedNews];
    }
   behold: function() {
      var dictTester = function (h) {
	[self assert: '2009-03-05' equals: [h valueForKey: 'date'] ];
	[self assert: [Time afternoon] equals: [h valueForKey: 'time' ]];
	[self assert: 'vm333' equals: [h valueForKey: 'course'] ];
	[self assert: 'fred' equals: [h valueForKey: 'instructor'] ];
	[self assert: ["procedure 1", "procedure 2"] equals: [h valueForKey: 'procedures']];
	 [self assert: ["animal 1", "animal 2"] equals: [h valueForKey: 'animals']];
 	return YES;
      }
      [sut.persistentStore shouldReceive: @selector(makeReservation:)
                                    with: dictTester
                                    andReturn: "reservation-identifier"];
    }];
}

-(void) testTellsReservationsDataControllerToOfferLinkToNewReservation
{
  [scenario
   during: function() {
      [self sendNotification: GroupingsDataCollectedNews];
    }
   behold: function() {
      // ...
      [sut.persistentStore shouldReceive: @selector(makeReservation:)
                               andReturn: "reservation-identifier"];
      [sut.reservationDataController shouldReceive: @selector(offerReservationView:)
                                     with: "reservation-identifier"];
    }];
}

-(void) testInstructsControllersToPrepareForNewReservation
{
  [scenario
   during: function() {
      [self sendNotification: GroupingsDataCollectedNews];
    }
   behold: function() {
      // 
      [sut.reservationDataController shouldReceive: @selector(allowUserToChooseParticularCourseSession)];
      [sut.groupingsController shouldReceive: @selector(hideOnPageControls)];
      [sut.pageController shouldReceive: @selector(hideFloatingWindows)];
      [sut.pageController shouldReceive: @selector(setDisplayFloatingWindowsOnPageReveal:)
                                   with: NO];
    }];
}

@end
