@implementation Logger : CPObject
{
  CPArray log;
  int lineLength;
}

+ (id) defaultLogger
{
  return DefaultLogger;
}

- (id) init
{
  log = [CPArray array];
  lineLength = 160;
  return self;
}

- (void) log: (CPString) format, ...
{
  var text = ObjectiveJ.sprintf.apply(this, Array.prototype.slice.call(arguments, 2));
  var date = new Date();
  text = text.replace('<', '[');
  [log addObject: date.toLocaleTimeString() + " " + text];
}

- (CPString) text
{
  var with_lengthy_lines_split = [];
  for (i = 0; i < [log count]; i++)
  {
    var line = log[i];
    if ([line length] > lineLength)
      [with_lengthy_lines_split addObjectsFromArray: [self split: line]];
    else
      [with_lengthy_lines_split addObject: line]
  }
  return with_lengthy_lines_split.join("\n");
}

- (CPArray) split: line
{
  var retval = [];
  while ([line length] > 0)
  {
    [retval addObject: [line substringToIndex: lineLength]];
    line = [line substringFromIndex: lineLength];
  }
  return retval;
}

@end

DefaultLogger = [[Logger alloc] init];

