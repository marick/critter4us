@import <Critter4Us/page-for-adding-animals/AnimalDescriptionViewPAA.j>
@import <Critter4Us/test/testutil/ScenarioTestCase.j>

@implementation _AnimalDescriptionViewPAATest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[AnimalDescriptionViewPAA alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardOutlets: ['nameField', 'speciesPopUp', 'noteField']];
}

- (void) test_setting_species_updates_title
{
  [scenario
    during: function() {
      [sut setSpecies: "name"];
    }
  behold: function() { 
      [sut.speciesPopUp shouldReceive: @selector(selectItemWithTitle:)
                                 with: "name"];
    }];
}

@end
