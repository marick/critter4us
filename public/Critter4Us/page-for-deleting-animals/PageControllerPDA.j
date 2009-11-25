@import "../controller/PageController.j"

@implementation PageControllerPDA : PageController
{
}

- (void) appear
{
  [super appear];
  [NotificationCenter postNotificationName: UserWantsToDeleteAnimalsNews
                                    object: nil];
}

@end
