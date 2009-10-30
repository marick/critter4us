@import <Critter4Us/page-for-making-reservations/CoordinatorPMR.j>
@import <Critter4Us/model/Animal.j>
@import <Critter4Us/model/Procedure.j>
@import <Critter4Us/model/Group.j>
@import "ScenarioTestCase.j"


@implementation CoordinatorPMRTest : ScenarioTestCase
{
  Animal betsy;
  Animal jake;
  Animal fang;
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
  jake = [[Animal alloc] initWithName: 'jake' kind: 'horse'];
  jake = [[Animal alloc] initWithName: 'fang' kind: 'dog'];
  floating = [[Procedure alloc] initWithName: 'floating'];
  radiology = [[Procedure alloc] initWithName: 'radiology'];
  someGroup = [[Group alloc] initWithProcedures: [floating, radiology]
                                        animals: [jake, betsy]];

}

















- (void) XtestRespondToNeedToEdit
  // This doesn't detail all of the steps, only those that set data.
{
    }];
}

- (void) XtestAModificationRequestMeansThatFinishingEditingSavesReservationInsteadOfCreatingANewOne
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


- (void) XtestRespondToChangeInDateTime
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


-(void) XtestReceivingUpdatedInformationUpdatesAnimalAndProcedureControllers
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



-(void) XtestReceivingUpdatedInformationUpdatesGroups
{
  var dict = [CPDictionary dictionary];
  [dict setValue: "...procedures..." forKey: 'procedures']
  [scenario
   during: function() {
      [self sendNotification: UpdatedDataForACourseSessionNews
                  withObject: dict];
    }
   behold: function() {
      [sut.groupController shouldReceive: @selector(exclusionsHaveChangedForThese:)
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

