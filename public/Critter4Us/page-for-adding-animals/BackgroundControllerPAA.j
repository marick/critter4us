@import <AppKit/AppKit.j>
@import "../util/AwakeningObject.j"

@implementation BackgroundControllerPAA : AwakeningObject
{
  CPPopUpButton defaultSpeciesPopUp;
  CPPopUpButton defaultNoteField;
  CPArray animalDescriptionViews;
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

@end
