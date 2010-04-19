@import <AppKit/AppKit.j>
@import "../util/AwakeningObject.j"

@implementation BackgroundControllerPAA : AwakeningObject
{
  CPPopUpButton defaultSpeciesPopup;
  CPPopUpButton defaultNoteField;
  CPArray animalDescriptions;
}


- (void) newDefaultSpecies: sender
{
  var title = [defaultSpeciesPopup selectedItemTitle];
  for (i = 0; i < [animalDescriptions count]; i++)
    {
      [animalDescriptions[i] setDefaultSpecies: title];
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
