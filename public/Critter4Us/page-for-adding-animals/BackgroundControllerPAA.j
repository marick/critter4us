@import <AppKit/AppKit.j>
@import "../util/AwakeningObject.j"

@implementation BackgroundControllerPAA : AwakeningObject
{
  CPPopUpButton defaultSpeciesPopUp;
  CPPopUpButton defaultNoteField;
  CPArray animalDescriptionViews;
  CPTextField resultField;
}


- (void) newDefaultSpecies: sender
{
  var title = [defaultSpeciesPopUp selectedItemTitle];
  for (i = 0; i < [animalDescriptionViews count]; i++)
    {
      [animalDescriptionViews[i] setSpecies: title];
    }
}

- (void) controlTextDidChange: aNotification
{
  var note = [defaultNoteField stringValue];
  for (i = 0; i < [animalDescriptionViews count]; i++)
    {
      [animalDescriptionViews[i] setNote: note];
    }
}

  
- (void) addAnimals: sender 
{
  [NotificationCenter postNotificationName: UserWantsToAddAnimals
                                    object: [self fetchAnimalDescriptions]]; 
}


- (CPArray) fetchAnimalDescriptions
{
  var retval = [];
  for (i = 0; i < [animalDescriptionViews count]; i++)
    {
      var description = [animalDescriptionViews[i] animalDescription];
      if (! [description.name isEqual: ""])
	{
	  [retval addObject: description];
	}
    }
  return retval;
}

- (void) clearForFurtherAdditions
{
  var replacement = [AnimalDescription namelessWithSpecies: [defaultSpeciesPopUp selectedItemTitle]
						      note: [defaultNoteField stringValue]];

  for (i = 0; i < [animalDescriptionViews count]; i++)
    {
      [animalDescriptionViews[i] setAnimalDescription: replacement];
    }
}

- (void) populatePageWithAnimals: animalDescriptions
{
  for (i = 0; i < [animalDescriptions count]; i++)
    {
      var replacement = animalDescriptions[i];
      [animalDescriptionViews[i] setAnimalDescription: replacement];
    }
}

- (void) describeSuccess
{
  [resultField setStringValue: "All the new animals were added."];
  [resultField setTextColor: [CPColor colorWithRed: 0.1
					     green: 0.4
					      blue: 0.0
					     alpha: 1.0]];
}

- (void) describeFailure: howManyConflicts
{
  var message = (howManyConflicts == 1) ? 
    "The animal shown to the left could not be added because there is already an animal with that name." :
    "The animals shown to the left could not be added because there are already animals with those names.";
  [resultField setStringValue: message];
  [resultField setTextColor: [CPColor redColor]];
}

@end
