@import "../../cib/Subgraph.j"
@import "../BackgroundControllerPDA.j"


@implementation BackgroundControllerSubgraphPDA : Subgraph
{
  BackgroundControllerPDA controller;
  CPTextField dateField;
}


-(id) initOnPage: pageView
{
  controller = [self custom: [[BackgroundControllerPDA alloc] init]];

  var dateInstructionLabel = [[CPTextField alloc] initWithFrame:CGRectMake(10, 30, 440, 30)];
  [dateInstructionLabel setStringValue: "On what date should the animals be taken out of service? "];
  [pageView addSubview: dateInstructionLabel];
  
  dateField = [[CPTextField alloc] initWithFrame:CGRectMake(330, 25, 100, 30)];
  [dateField setEditable:YES];
  [dateField setBezeled:YES];
  var date = new Date();
  [dateField setStringValue: [CPString stringWithFormat: "%d-%d-%d", date.getFullYear(), date.getMonth()+1, date.getDate()]];
  [pageView addSubview:dateField];

  var showButton = [[CPButton alloc] initWithFrame:CGRectMake(450, 28, 250, 30)];
  [showButton setTitle: "Show Animals In Service on that Date"];
  [showButton setHidden: NO];
  [pageView addSubview:showButton];
  controller.showButton = showButton;
  [showButton setTarget: controller];
  [showButton setAction: @selector(animalsInServiceForDate:)];



  //  var instructionLabel = [[CPTextField alloc] initWithFrame:CGRectMake(10, 30, 400, 30)];
  //  [instructionLabel setStringValue: "Choose an animal to take out of service:"];
  //  [pageView addSubview: instructionLabel];
  


  return self;
}

- (void) connectOutlets
{
  controller.dateField = dateField;
}

@end
