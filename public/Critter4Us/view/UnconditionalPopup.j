
@implementation UnconditionalPopup : CPObject
{
  CPString message;
}

- (void) setMessage: aString
{
  message = aString;
}

- (CPString) message
{
  return message;
}

- (void) run
{
  alert(message);
}

@end

