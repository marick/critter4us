@import <Critter4Us/page-for-making-reservations/CoordinatorPMR.j>
@import <Critter4Us/model/Animal.j>
@import <Critter4Us/model/Procedure.j>
@import <Critter4Us/model/Group.j>
@import "ScenarioTestCase.j"


@implementation CoordinatorPMRTest : ScenarioTestCase
{
  Animal betsy;
  Animal jake;
  Procedure floating;
  Procedure radiology;

  Group someGroup;
}

- (void)setUp
{
  sut = [[CoordinatorPMR alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardOutlets: ['reservationDataController', 'animalController', 'procedureController', 'groupController', 'pageController']];
  [scenario sutHasDownwardOutlets: ['persistentStore']];

  betsy = [[Animal alloc] initWithName: 'betsy' kind: 'cow'];
  jake = [[Animal alloc] initWithName: 'jake' kind: 'cow'];
  floating = [[Procedure alloc] initWithName: 'floating'];
  radiology = [[Procedure alloc] initWithName: 'radiology'];
  someGroup = [[Group alloc] initWithProcedures: [floating, radiology]
                                        animals: [jake, betsy]];

}

- (void) testSetsUpControlsAppropriatelyWhenReservationDataIsAvailable
{
  [scenario
    during: function() {
      [self sendNotification: ReservationDataAvailable withObject: nil];
    }
  behold: function() {
      [sut.reservationDataController shouldReceive:@selector(prepareToFinishReservation)];
      [sut.groupController shouldReceive:@selector(prepareToEditGroups)];
      [sut.procedureController shouldReceive:@selector(appear)];
      [sut.animalController shouldReceive:@selector(appear)];
      [sut.groupController shouldReceive:@selector(appear)];
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
      [sut.persistentStore shouldReceive: @selector(loadInfoRelevantToDate:time:notificationName:)
                                    with: ['2009-02-02', [Time morning], InitialDataForACourseSessionNews]];
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
      [sut.animalController shouldReceive: @selector(allPossibleObjects:)
                                     with: [[animal]]];
      [sut.procedureController shouldReceive: @selector(allPossibleObjects:)
                                     with: [[proc]]];
    }];
}


-(void)testThatTellsAnimalControllerToUpdateWhenProceduresChange
{
  var animals = [ [[Animal alloc] initWithName: 'animal0' kind: 'cow'],
                  [[Animal alloc] initWithName: 'animal1' kind: 'horse'],
                  [[Animal alloc] initWithName: 'animal2' kind: 'horse']];

  var procedures = [ [[Procedure alloc] initWithName: 'procedure0'
                                           excluding: [animals[0]]],
                     [[Procedure alloc] initWithName: 'procedure1'
                                           excluding: [animals[2]]]];

  var userInfo = [CPDictionary dictionaryWithJSObject: {'used': procedures}];
  [scenario
   during: function() {
      [self sendNotification: DifferentObjectsUsedNews
                  withObject: sut.procedureController
                    userInfo: userInfo];
    }
   behold: function() {
      [sut.animalController shouldReceive:@selector(withholdAnimals:)
                                     with: [[animals[0], animals[2]]]];
    }];
}


-(void)testThatUpdatesRelevantControllersWhenReceivingNewsOfAnyChangeInWhatIsUsed
{
  [scenario
   during: function() {
      [self sendNotification: DifferentObjectsUsedNews];
    }
   behold: function() {
      [sut.groupController shouldReceive:@selector(updateCurrentGroup)];
    }];
}



-(void)testSwitchingToAGivenGroup
{
  [scenario
   during: function() {
      [self sendNotification: SwitchToGroupNews
                  withObject: someGroup];
    }
   behold: function() {
      [sut.animalController shouldReceive:@selector(presetUsed:)
                                     with: [[someGroup animals]]];
      [sut.procedureController shouldReceive:@selector(presetUsed:)
                                        with: [[someGroup procedures]]];
      // ...
    }];
}

-(void)testThatSwitchingToAGivenGroupMakesAnimalControllerUpdate
{
  var animals = [ [[Animal alloc] initWithName: 'animal0' kind: 'cow'],
                  [[Animal alloc] initWithName: 'animal1' kind: 'horse'],
                  [[Animal alloc] initWithName: 'animal2' kind: 'horse']];

  var procedures = [ [[Procedure alloc] initWithName: 'procedure0'
                                           excluding: [animals[0]]],
                     [[Procedure alloc] initWithName: 'procedure1'
                                           excluding: []]];

  var group = [[Group alloc] initWithProcedures: procedures animals: animals];
  [scenario
   during: function() {
      [self sendNotification: SwitchToGroupNews
                  withObject: group];
    }
   behold: function() {
      [sut.animalController shouldReceive:@selector(withholdAnimals:)
                                     with: [[animals[0]]]];
    }];
}

-(void) testCollectsReservationDataAndSendsToPersistentStore
{
  var group1 = [[Group alloc] initWithProcedures: [floating]
                                         animals: [betsy]];
  var group2 = [[Group alloc] initWithProcedures: [radiology]
                                         animals: [betsy]];


  [scenario
   previousAction: function() { 
      sut.reservationDataController = 
          [[Spiller alloc] initWithValue: {'date':'2009-03-05',
	                                   'time':[Time afternoon],
					   'course':'vm333',
					   'instructor':'fred'}];

      sut.groupController = 
    	  [[Spiller alloc] initWithValue: {'groups': [group1, group2]}];
    }
   during: function() {
      [self sendNotification: TimeToReserveNews];
    }
   behold: function() {
      // TODO: this level of detail is unnecessary.
      var dictTester = function (h) {
	[self assert: '2009-03-05' equals: [h valueForKey: 'date'] ];
	[self assert: [Time afternoon] equals: [h valueForKey: 'time' ]];
	[self assert: 'vm333' equals: [h valueForKey: 'course'] ];
	[self assert: 'fred' equals: [h valueForKey: 'instructor'] ];

        var group1actual = [[h valueForKey: 'groups'] objectAtIndex: 0];
        var group2actual = [[h valueForKey: 'groups'] objectAtIndex: 1];

        [self assert: [floating]
              equals: [group1actual valueForKey: 'procedures']];
        [self assert: [betsy]
              equals: [group1actual valueForKey: 'animals']];

        [self assert: [radiology]
              equals: [group2actual valueForKey: 'procedures']];
        [self assert: [betsy]
              equals: [group2actual valueForKey: 'animals']];

 	return YES;
      }
      [sut.persistentStore shouldReceive: @selector(makeReservation:)
                                    with: dictTester
                                    andReturn: "reservation-identifier"];
    }];
}

-(void) testTellsReservationDataControllerToOfferLinkToNewReservation
{
  [scenario
   during: function() {
      [self sendNotification: TimeToReserveNews];
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
      [self sendNotification: TimeToReserveNews];
    }
   behold: function() {
      [sut.reservationDataController shouldReceive: @selector(beginningOfReservationWorkflow)];
      [sut.animalController shouldReceive: @selector(beginningOfReservationWorkflow)];
      [sut.procedureController shouldReceive: @selector(beginningOfReservationWorkflow)];
      [sut.groupController shouldReceive: @selector(beginningOfReservationWorkflow)];
      [self listenersShouldReceiveNotification: AdvisoriesAreIrrelevantNews];
    }];
}

- (void) testRespondToNeedToEdit
  // This doesn't detail all of the steps, only those that set data.
{
  [scenario
   during: function() {
      [self sendNotification: ModifyReservationNews
                  withObject: 33];
    }
   behold: function() {
      var dict = [CPDictionary dictionary];
      [dict setValue: 'animal list' forKey: 'animals'];
      [dict setValue: 'procedure list' forKey: 'procedures'];
      [dict setValue: 'group list' forKey: 'groups'];
      [sut.persistentStore shouldReceive: @selector(reservation:)
                                    with: 33
                               andReturn: dict];
      [sut.reservationDataController shouldReceive: @selector(edit:)
                                              with: dict];
      [sut.animalController shouldReceive: @selector(allPossibleObjects:)
                                     with: [dict valueForKey: 'animals']];
      [sut.procedureController shouldReceive: @selector(allPossibleObjects:)
                                     with: [dict valueForKey: 'procedures']];
      [sut.groupController shouldReceive: @selector(allPossibleObjects:)
                                     with: [dict valueForKey: 'groups']];
    }];
}

- (void) testAModificationRequestMeansThatFinishingEditingSavesReservationInsteadOfCreatingANewOne
{
  [scenario
    previousAction: function() { 
      [self sendNotification: ModifyReservationNews
                  withObject: 33];
      sut.reservationDataController = 
        [[Spiller alloc] initWithValue: {'reservation data': 'to be passed along'}];
      sut.groupController = 
        [[Spiller alloc] initWithValue: {'group data' : 'to be passed along too'}];
    }
   during: function() {
      [self sendNotification: TimeToReserveNews];
    }
   behold: function() {
    [sut.persistentStore shouldReceive:@selector(updateReservation:with:)
                                  with: [33, function(dict) {
          [self assert: 'to be passed along'
                equals: [dict valueForKey: 'reservation data']];
          [self assert: 'to be passed along too'
                equals: [dict valueForKey: 'group data']];
          return YES;
          }]];
    }];
}


- (void) testRespondToChangeInDateTime
{
  var dict = [CPDictionary dictionary];
  [dict setValue: '2009-02-02' forKey: 'date'];
  [dict setValue: [Time morning] forKey: 'time'];
  [scenario
   during: function() {
      [self sendNotification: DateTimeForCurrentReservationChangedNews
                  withObject: dict];
    }
   behold: function() {
      [sut.persistentStore shouldReceive: @selector(loadInfoRelevantToDate:time:notificationName:)
                                    with: ['2009-02-02', [Time morning], UpdatedDataForACourseSessionNews]];
    }];
}


-(void) testReceivingUpdatedInformationUpdatesAnimalAndProcedureControllers
{
  var animal = [[Animal alloc] initWithName: "fred" kind: 'cow'];
  var proc = [[Procedure alloc] initWithName: 'procme'];
  var jsdict = {'animals':[animal], 'procedures':[proc]};
  var dict = [CPDictionary dictionaryWithJSObject: jsdict];
  [scenario
   during: function() {
      [self sendNotification: UpdatedDataForACourseSessionNews
                  withObject: dict];
    }
   behold: function() {
      [sut.animalController shouldReceive: @selector(allPossibleObjects:)
                                     with: [[animal]]];
      [sut.procedureController shouldReceive: @selector(allPossibleObjects:)
                                     with: [[proc]]];
    }];
}



-(void) testReceivingUpdatesGroups
{
  var dict = [CPDictionary dictionary];
  [dict setValue: "...procedures..." forKey: 'procedures']
  [scenario
   during: function() {
      [self sendNotification: UpdatedDataForACourseSessionNews
                  withObject: dict];
    }
   behold: function() {
      [sut.groupController shouldReceive: @selector(updateProcedures:)
                                    with: [dict valueForKey: 'procedures']];
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
