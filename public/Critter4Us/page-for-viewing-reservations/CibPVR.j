@import "../util/Constants.j"
@import "../cib/HtmlViewingCib.j"
@import "PageControllerPVR.j"

@implementation CibPVR : HtmlViewingCib
{
  CritterPopUpButton daysPopUp;
  PageControllerPVR pageController;
}

- (void)instantiatePageInWindow: (CPWindow) window withOwner: (CPObject) owner
{
  [super instantiatePageInWindow: window withOwner: owner];

  var beforeLabel = [[CPTextField alloc] initWithFrame: CGRectMake(18, 30, 200, 30)];
  [beforeLabel setStringValue: "Show reservations for the last" ];
  [pageView addSubview: beforeLabel];

  daysPopUp = [[CritterPopUpButton alloc] initWithFrame: CGRectMake(187, 25, 85, 30)
					      pullsDown: NO];
  [daysPopUp addItemsWithTitles: ["30", "60", "90", "365", "bazillion"]];
  [daysPopUp selectItemWithTitle: "30"];
  [daysPopUp setTarget: pageController];
  [daysPopUp setAction: @selector(changeDays:)]
  [pageView addSubview: daysPopUp];
  pageController.daySelection = daysPopUp;

 

  var afterLabel = [[CPTextField alloc] initWithFrame: CGRectMake(275, 30, 200, 30)];
  [afterLabel setStringValue: "days." ];
  [pageView addSubview: afterLabel];

}


- (id) tableVerticalOffset
{
  return 40;
}

- (id) makePageControllerUnder: owner
{
  pageController = [[PageControllerPVR alloc] init];
  owner.pvrPageController = pageController;	
  return pageController;
}

@end

