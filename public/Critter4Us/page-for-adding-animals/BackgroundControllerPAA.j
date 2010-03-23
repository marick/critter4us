@import <AppKit/AppKit.j>
@import "../util/AwakeningObject.j"

@implementation BackgroundControllerPAA : AwakeningObject
{
  CPTextField nameField;
  CPComboBox kindField;
  CPComboBox speciesField;
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
