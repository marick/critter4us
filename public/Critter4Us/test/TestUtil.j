
cpdict = function(jsHash) {
  var retval = [CPDictionary dictionaryWithJSObject: jsHash recursively: YES];  
  return retval;
}
