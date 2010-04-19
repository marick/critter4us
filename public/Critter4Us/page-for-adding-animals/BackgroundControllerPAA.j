@import <AppKit/AppKit.j>
@import "../util/AwakeningObject.j"

@implementation BackgroundControllerPAA : AwakeningObject
{
  CPPopUpButton defaultSpeciesPopUp;
  CPPopUpButton defaultNoteField;
  CPArray animalDescriptions;
}


- (void) newDefaultSpecies: sender
{
  var title = [defaultSpeciesPopUp selectedItemTitle];
  for (i = 0; i < [animalDescriptions count]; i++)
    {
      [animalDescriptions[i] setSpecies: title];
    }
}

  
- (void) startAddingAnimal: sender 
{
  var animal = [CPDictionary dictionaryWithJSObject: {
        'name': 'Clara', 
        'kind': 'cow', 
        'species': 'bovine'}]
  [NotificationCenter postNotificationName: UserWantsToAddAnAnimal
                                    object: animal]; 
}


@end
