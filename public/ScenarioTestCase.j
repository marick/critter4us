@import "Mock.j"
@import "Scenario.j"

@implementation ScenarioTestCase : OJTestCase
{
  CPObject sut;
  Scenario scenario;
}

- (void)tearDown
{
  [sut stopObserving];
}


- (void) tablesWillBeMadeHidden
{
  [sut.containingView shouldReceive: @selector(setHidden:) with: YES];
}

- (void) tableWillBeMadeHidden // synonym
{
  [self tablesWillBeMadeHidden];
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

@end
