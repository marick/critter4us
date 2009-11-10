@import <AppKit/AppKit.j>
@import "../util/CritterObject.j"

@implementation Spinner : CritterObject
{
  CPView spinnerView;
  CPView superView;
}

- (id) initHeadless
{
  self = [super init];
  [self setUpNotifications];
  return self;
}

- (void) setUpNotifications
{
  [self notificationNamed: BusyNews
                    calls: @selector(busy:)];
  [self notificationNamed: AvailableNews
                    calls: @selector(available:)];
}


- (id) initWithin: window
{
  self = [self initHeadless];

  superView = [window contentView];

  var outsideRect = [window frame];
  spinnerView = [[CPView alloc] initWithFrame: outsideRect];

  var xStep = outsideRect.size.width / 5;
  var yStep = outsideRect.size.height / 5;
  for (var x = xStep; x < outsideRect.size.width; x += xStep)
    for (var y = 10; y < outsideRect.size.height; y += yStep)
    {
      var rect = CGRectMake(x, y, 16, 16);
      var imageView = [[CPImageView alloc] initWithFrame: rect];
      var image = [[CPImage alloc] initWithContentsOfFile:@"Resources/spinner.gif"
                                                     size:CGSizeMake(16, 16)];
      [imageView setImage: image];
      [spinnerView addSubview: imageView];
    }
  return self;
}



-(void) busy: aNotification
{
  [superView addSubview: spinnerView
             positioned: CPWindowAbove
             relativeTo: nil];
}

-(void) available: aNotification
{
  [spinnerView removeFromSuperview];
}

@end
