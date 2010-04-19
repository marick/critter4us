@import <Critter4Us/page-for-adding-animals/BackgroundControllerPAA.j>
@import <Critter4Us/test/testutil/ScenarioTestCase.j>

@implementation _BackgroundControllerPAATest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[BackgroundControllerPAA alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardOutlets: ['defaultSpeciesPopup', 'defaultNoteField']];
  [scenario makeOneMock: 'firstRow'];
  [scenario makeOneMock: 'nextRow'];
  sut.animalDescriptions = [ sut.firstRow, sut.nextRow ];
}

- (void) test_that_changing_the_default_species_propagates 
{
  [scenario 
    during: function() {
      [sut newDefaultSpecies: UnusedArgument];
    }
  behold: function() { 
      [sut.defaultSpeciesPopup shouldReceive: @selector(selectedItemTitle)
				   andReturn: "a title"];
      [sut.firstRow shouldReceive: @selector(setDefaultSpecies:)
			     with: "a title"];
      [sut.nextRow shouldReceive: @selector(setDefaultSpecies:)
			    with: "a title"];
    }];
}

@end
