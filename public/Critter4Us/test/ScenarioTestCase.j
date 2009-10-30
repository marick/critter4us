@import "Mock.j"
@import "Scenario.j"

@implementation ScenarioTestCase : OJTestCase
{
  CPObject sut;
  Scenario scenario;
}

- (void)tearDown
{
  if ([sut respondsToSelector: @selector(stopObserving)])
  {
    [sut stopObserving];
  }
  if (scenario)
  {
    [[CPNotificationCenter defaultCenter] removeObserver: scenario.randomListener];
  }
}


- (void) controlsWillBeMadeHidden
{
  [sut.containingView shouldReceive: @selector(setHidden:) with: YES];
}

- (void) controlsWillBeMadeVisible
{
  [sut.containingView shouldReceive: @selector(setHidden:) with: NO];
}


- (void) sendNotification: (CPString) aName
{
  [self sendNotification: aName withObject: nil];
}

- (void) sendNotification: aName withObject: anObject
{
  [[CPNotificationCenter defaultCenter] postNotificationName: aName
                                        object: anObject];
}

- (void) sendNotification: aName withObject: anObject userInfo: info
{
  [[CPNotificationCenter defaultCenter] postNotificationName: aName
                                                      object: anObject
                                                    userInfo: info];
}


- (void) notifyOfChosenProcedures: (CPArray)anArray
{
  [self sendNotification: ProcedureUpdateNews withObject: anArray];
}



- (void) onlyColumnInTable: aTable named: aString willContain: anArray
{
  [self column: 'irrelevant' inTable: aTable named: aString willContain: anArray];
}

- (void) column: column inTable: aTable named: aString willContain: anArray
{
  [self assertColumn: column
        inTable: aTable
        contains: anArray
        message: [CPString stringWithFormat: @"%s should contain %s", aString, [anArray description]]];
}

-(void) assertColumn: column inTable: aTable contains: anArray message: aMessage
{
  [self assert: [anArray count]
        equals: [sut numberOfRowsInTableView: aTable]
	message: aMessage];
  for(var i=0; i<[anArray count]; i++)
    {
      [self assert: [anArray objectAtIndex: i]
            equals: [sut tableView: aTable
		         objectValueForTableColumn: column
		         row: i]];
    }
}


// TODO: Finish replacing all "will" forms with "should" forms.

- (void) listenersShouldReceiveNotification: (CPString) aNotificationName containingObject: (id) anObject
{
  [self listenersWillReceiveNotification:aNotificationName
   checkingWith:function(notification) {
      if ([[notification object] isEqual: anObject])
      {
        return YES;
      }
      //      CPLog("Expectation failure for listeners:")
      //CPLog("notification name: " + [notification name]);
      //CPLog("notification object: " + [[notification object] description]);
      //CPLog("expected object: "+ [anObject description]);
      return NO;
    }];
}
- (void) listenersWillReceiveNotification: (CPString) aNotificationName containingObject: (id) anObject
{
  [self listenersShouldReceiveNotification: aNotificationName containingObject: anObject];
}
      
- (void) listenersShouldReceiveNotification: (CPString) aNotificationName containingObject: (id) anObject andKey: key with: value
{
  [self listenersWillReceiveNotification:aNotificationName
                            checkingWith:function(notification) {
      if (! [anObject isEqual: [notification object]]) 
      {
        CPLog([anObject description] + " should equal " + [[notification object] description]);
        return NO;
      }
      if (! [value isEqual: [[notification userInfo] valueForKey: key]])
      {
        CPLog(value + " should equal " + [[notification userInfo] valueForKey: key]);
        return NO;
      }
      return YES;
    }];
}
- (void) listenersWillReceiveNotification: (CPString) aNotificationName containingObject: (id) anObject andKey: key with: value
{
  [self listenersShouldReceiveNotification: aNotificationName containingObject: anObject
                                    andKey: key with: value];
}
      
- (void) listenersShouldReceiveNotification: (CPString) aNotificationName
{
  [self listenersWillReceiveNotification:aNotificationName
   checkingWith:function(notification) {
      return YES;
    }];
}
- (void) listenersWillReceiveNotification: (CPString) aNotificationName
{
  [self listenersShouldReceiveNotification: aNotificationName];
}
      
-(void) listenersShouldReceiveNotification: (CPString) aNotificationName checkingWith: (id)aFunction
{
  var selector = CPSelectorFromString([aNotificationName stringByReplacingOccurrencesOfString: " " withString: ""]);

  [[CPNotificationCenter defaultCenter]
   addObserver: scenario.randomListener
   selector: selector
   name: aNotificationName
   object: nil];

  [scenario.randomListener shouldReceive: selector
                           with: aFunction];
}
-(void) listenersWillReceiveNotification: (CPString) aNotificationName checkingWith: (id)aFunction
{
  [self listenersShouldReceiveNotification: aNotificationName checkingWith: aFunction];
}


-(void) listenersShouldHearNo: notificationName
{
  [[CPNotificationCenter defaultCenter]
   addObserver: scenario.randomListener
      selector: @selector(ifThisIsCalledItMeansNotificationWasIncorrectlySent:)
          name: notificationName
        object: nil];
  scenario.randomListener.failOnUnexpectedSelector = YES;
}

@end

