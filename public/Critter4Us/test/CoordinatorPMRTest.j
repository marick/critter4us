@import <Critter4Us/page-for-making-reservations/CoordinatorPMR.j>
@import <Critter4Us/model/Animal.j>
@import <Critter4Us/model/Procedure.j>
@import "ScenarioTestCase.j"


@implementation CoordinatorPMRTest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[CoordinatorPMR alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardCollaborators: ['reservationDataController', 'animalController', 'procedureController', 'workupHerdController', 'pageController']];
  [scenario sutHasDownwardCollaborators: ['persistentStore']];
}

- (void) testSetsUpControlsAppropriatelyWhenReservationDataIsAvailable
{
  [scenario
    during: function() {
      [self sendNotification: ReservationDataAvailable withObject: nil];
    }
  behold: function() {
      [sut.reservationDataController shouldReceive:@selector(allowNoDataChanges)];
      [sut.reservationDataController shouldReceive:@selector(prepareToFinishReservation)];
      [sut.procedureController shouldReceive:@selector(appear)];
      [sut.animalController shouldReceive:@selector(appear)];
      [sut.workupHerdController shouldReceive:@selector(appear)];
    }];
}

-(void) testAsksPersistentStoreForInformationWhenReservationDataIsAvailable
{
  var animals = [  [[Animal alloc] initWithName: 'animal1' kind: 'cow'],
                   [[Animal alloc] initWithName: 'animal2' kind: 'horse']];

  var procedures = [ [[Procedure alloc] initWithName: 'procedure1'],
                     [[Procedure alloc] initWithName: 'procedure2']];
  [scenario
   during: function() {
      var dict = [CPDictionary dictionary];
      [dict setValue: '2009-02-02' forKey: 'date'];
      [dict setValue: [Time morning] forKey: 'time'];
          
      [self sendNotification: ReservationDataAvailable withObject: dict];
    }
   behold: function() {
      [sut.persistentStore shouldReceive: @selector(loadInfoRelevantToDate:time:)
                                    with: ['2009-02-02', [Time morning]]];
    }];
}
-(void) testPassesNewInformationAlongToControllers
{
  var animal = [[Animal alloc] initWithName: "fred" kind: 'cow'];
  var proc = [[Procedure alloc] initWithName: 'procme'];
  var jsdict = {'animals':[animal], 'procedures':[proc]};
  var dict = [CPDictionary dictionaryWithJSObject: jsdict];
  [scenario
   during: function() {
      [self sendNotification: InitialDataForACourseSessionNews
                  withObject: dict];
    }
   behold: function() {
      [sut.animalController shouldReceive: @selector(beginUsing:)
                                     with: [[animal]]];
      [sut.procedureController shouldReceive: @selector(beginUsing:)
                                     with: [[proc]]];
    }];
}


-(void)testThatUpdatesAnimalControllerWhenReceivingProcedureNotification
{
  var animals = [ [[Animal alloc] initWithName: 'animal0' kind: 'cow'],
                  [[Animal alloc] initWithName: 'animal1' kind: 'horse'],
                  [[Animal alloc] initWithName: 'animal2' kind: 'horse']];

  var procedures = [ [[Procedure alloc] initWithName: 'procedure0'
                                           excluding: [animals[0]]],
                     [[Procedure alloc] initWithName: 'procedure1'
                                           excluding: [animals[2]]]];
  [scenario
   during: function() {
      [self sendNotification: ProceduresChosenNews
                  withObject: procedures];
    }
   behold: function() {
      [sut.animalController shouldReceive:@selector(withholdAnimals:)
                                     with: [[animals[0], animals[2]]]];
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
      sut.procedureController = 
    	  [[Spiller alloc] initWithValue: {'procedures':
					   ['procedure 1','procedure 2']}];

      sut.animalController = 
	[[Spiller alloc] initWithValue: {'animals':
					 ['animal 1', 'animal 2']}];
    }
   during: function() {
      [self sendNotification: TimeToReserveNews];
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


@end

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
