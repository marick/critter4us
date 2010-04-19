@import <Critter4Us/page-for-adding-animals/BackgroundControllerPAA.j>
@import <Critter4Us/test/testutil/ScenarioTestCase.j>
@import <Critter4Us/util/AnimalDescription.j>

@implementation _BackgroundControllerPAATest : ScenarioTestCase
{
}

- (void)setUp
{
  sut = [[BackgroundControllerPAA alloc] init];
  scenario = [[Scenario alloc] initForTest: self andSut: sut];
  [scenario sutHasUpwardOutlets: ['defaultSpeciesPopUp', 'defaultNoteField']];
  [scenario makeOneMock: 'firstRow'];
  [scenario makeOneMock: 'nextRow'];
  sut.animalDescriptionViews = [ sut.firstRow, sut.nextRow ];
}

- (void) test_that_changing_the_default_species_propagates 
{
  [scenario 
    during: function() {
      [sut newDefaultSpecies: UnusedArgument];
    }
  behold: function() { 
      [sut.defaultSpeciesPopUp shouldReceive: @selector(selectedItemTitle)
				   andReturn: "a title"];
      [sut.firstRow shouldReceive: @selector(setSpecies:)
			     with: "a title"];
      [sut.nextRow shouldReceive: @selector(setSpecies:)
			    with: "a title"];
    }];
}


- (void) test_that_changing_the_default_note_propagates 
{
  [scenario 
    during: function() {
      [sut controlTextDidChange: UnusedArgument];
    }
  behold: function() { 
      [sut.defaultNoteField shouldReceive: @selector(stringValue)
				   andReturn: "blah"];
      [sut.firstRow shouldReceive: @selector(setNote:)
			     with: "blah"];
      [sut.nextRow shouldReceive: @selector(setNote:)
			    with: "blah"];
    }];
}

- (void) test_notifies_listeners_that_animals_are_to_be_added
{
  var firstAnimal = [[AnimalDescription alloc] initWithName: 'bossy'
						    species: 'bovine'
						       note: 'cow'];
  var nextAnimal = [[AnimalDescription alloc] initWithName: 'fred'
						   species: 'equine'
						      note: 'gelding'];

  [scenario 
    during: function() {
      [sut addAnimals: UnusedArgument];
    }
  behold: function() { 
      [sut.firstRow shouldReceive: @selector(animalDescription)
			andReturn: firstAnimal];
      [sut.nextRow shouldReceive: @selector(animalDescription)
		       andReturn: nextAnimal];
      [self listenersShouldReceiveNotification: UserWantsToAddAnimals
				  checkingWith: function(notification) {
	  var animals = [notification object];
	  [self assert: 2 equals: [animals count]];
	  [self assert: firstAnimal equals: animals[0]];
	  [self assert: nextAnimal equals: animals[1]];
	  return YES;
	}];
    }];
}

@end
