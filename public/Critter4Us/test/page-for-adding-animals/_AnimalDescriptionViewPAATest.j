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

- (void) test_note_updates_text_field
{
  [scenario
    during: function() {
      [sut setNote: "blah"];
    }
  behold: function() { 
      [sut.noteField shouldReceive: @selector(setStringValue:)
                              with: "blah"];
    }];
}

- (void) test_bundles_up_values
{

  var expected = [[AnimalDescription alloc] initWithName: "name"
                                                 species: "species"
                                                    note: "note"];
  [scenario
    during: function() {
      return [sut animalDescription];
    }
  behold: function() { 
      [sut.nameField shouldReceive: @selector(stringValue)
                         andReturn: expected.name];
      [sut.speciesPopUp shouldReceive: @selector(selectedItemTitle)
                         andReturn: expected.species];
      [sut.noteField shouldReceive: @selector(stringValue)
                         andReturn: expected.note];
     }
  andSo: function() {
      [self assert: expected equals: scenario.result];
    }];
}

@end
