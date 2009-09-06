// These constants are specific to layout of reservation GUI objects.

ProcedureHintColor = [CPColor colorWithRed: 0.8 green: 1.0 blue: 0.8 alpha: 1.0];
ProcedureStrongHintColor = [CPColor colorWithRed: 0.4 green: 1.0 blue: 0.4 alpha: 1.0];
AnimalHintColor = [CPColor colorWithRed: 1.0 green: 0.8 blue: 0.8 alpha: 1.0];
AnimalStrongHintColor = [CPColor colorWithRed: 1.0 green: 0.4 blue: 0.4 alpha: 1.0];

WindowBottomMargin = 20;
ScrollbarWidth = 20;
TextLineHeight = 20;

FarthestLeftWindowX = 10;
WindowTops = 200;

CompleteTextLineWidth = 250-ScrollbarWidth;
TruncatedTextLineWidth = 200;
DragSourceNumberOfLines = 15;
// TODO: Not actually right, since TextLineHeight doesn't include interspacing.
DragSourceWindowHeight = DragSourceNumberOfLines * TextLineHeight;
DragSourceWindowWidth = CompleteTextLineWidth + ScrollbarWidth;

FirstGroupingWindowX = FarthestLeftWindowX + DragSourceWindowWidth + 20;
GroupingWindowVerticalMargin = 10 ;
TargetWidth = TruncatedTextLineWidth;
GroupingWindowWidth = TargetWidth * 2 + GroupingWindowVerticalMargin * 3;
TargetNumberOfLines = 10; // Ditto TODO above
TargetViewHeight = TargetNumberOfLines * TextLineHeight;
TargetWindowHeight = TargetViewHeight + WindowBottomMargin;
FirstTargetX = GroupingWindowVerticalMargin
SecondTargetX = FirstTargetX + TargetWidth + GroupingWindowVerticalMargin

FarthestRightWindowX = FirstGroupingWindowX + GroupingWindowWidth + 20

