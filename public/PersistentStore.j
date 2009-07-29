@import <Foundation/CPObject.j>

@implementation PersistentStore : CPObject
{
  
}

- (CPArray) allAnimalNames
{
  return [self doRequest: "all_animals" forKey: "animals"];
}

- (CPArray) allProcedureNames
{
  return [self doRequest: "procedures" forKey: "procedures"];
}

- (CPDictionary) exclusionsForDate: (CPString)dateString
{
  request = [CPString stringWithFormat: "exclusions?date=%s", dateString];
  return [self doRequest: request forKey: "exclusions"];
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
  return [CPArray arrayWithArray: json[aKey]]
}

@end

