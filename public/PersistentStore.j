@import <Foundation/CPObject.j>

@implementation PersistentStore : CPObject
{
  
}

- (CPArray) allAnimalNames
{
  var retval = [self doRequest: "all_animals" forKey: "animals"];
  return [CPArray arrayWithArray: retval];
}

- (CPArray) allProcedureNames
{
  var retval = [self doRequest: "procedures" forKey: "procedures"];
  return [CPArray arrayWithArray: retval];
}

- (CPDictionary) exclusionsForDate: (CPString)dateString
{
  var request = [CPString stringWithFormat: "exclusions?date=%s", dateString];
  var retval =  [self doRequest: request forKey: "exclusions"];
  return [CPDictionary dictionaryWithJSObject: retval
                       recursively: YES];
}	

// util

- (CPArray) doRequest: (CPString)aString forKey: (CPString)aKey
{
  url = [CPString stringWithFormat: @"http://localhost:7000/json/%s", aString];
  var request = [CPURLRequest requestWithURL: url];
  var data = [CPURLConnection sendSynchronousRequest: request   
	      returningResponse:nil error:nil]; 
  var str = [data description];
  var json = [str objectFromJSON];
  return json[aKey];
}

@end

