@import <AppKit/CPCollectionView.j>
@import "DebuggableCollectionView.j"

@implementation ButtonCollectionView : CPCollectionView
{
  CPInteger currentIndex;
  CPString defaultName;
  id target;
  SEL action;
}

- (id) initWithFrame: rect
{
  self = [super initWithFrame: rect];
  [self setMinItemSize:CGSizeMake(300, TextLineHeight)];
  [self setMaxItemSize:CGSizeMake(300, TextLineHeight)];
  var itemPrototype = [[ButtonCollectionViewItem alloc] init];
  var button = [[ConformingButton alloc]
                     initWithFrame: CGRectMakeZero()];
  [itemPrototype setView: button];
  [self setItemPrototype:itemPrototype];
  [self becomeEmpty];
  defaultName = '';
  return self;
}

- (void) setDefaultName: aString
{
  defaultName = aString;
}

- (CPString) defaultName
{
  return defaultName;
}


- (void) setTarget: anObject
{
  target = anObject;
}

- (CPString) target
{
  return target;
}

- (void) setAction: (SEL) anAction
{
  action = anAction;
}

- (CPString) action
{
  return action;
}

// Less boring stuff

- (void) becomeEmpty
{
  [self setContent: []];
  currentIndex = -1;
}

- (void) addNamedObjectToContent: anObject
{
  var content = [[self content] copy];
  [content addObject: anObject];
  [self setContent: content];
  [self currentItemIsAtIndex: (currentIndex+1)];
}

-(void) currentItemIsAtIndex: index
{
  [[[self items] objectAtIndex: currentIndex] sinkBackIntoObscurity];
  currentIndex = index;
  [[[self items] objectAtIndex: currentIndex] distinguishYourself];
}


- (id) currentRepresentedObject
{
  return [[self content] objectAtIndex: currentIndex];
}

- (void) currentNameHasChanged
{
  [[[self items] objectAtIndex: currentIndex] refreshButtonTitle];
}

- (void) clickOn: item
{
  var index = [[self items] indexOfObject: item];
  [self currentItemIsAtIndex: index];
  [[CPApplication sharedApplication] sendAction: [self action]
                                             to: [self target]
                                           from: self];
}

// overrides

- (CPCollectionViewItem) newItemForRepresentedObject: (id) anObject
{
  var item = [super newItemForRepresentedObject: anObject];
  [item setContainingCollectionView: self]; // See note in ButtonCollectionViewItem
  // Following has to be done in this object because the item's 
  // setRepresentedObject is done before the previous line.
  [item refreshButtonTitle];
  return item;
}


@end

@implementation ButtonCollectionViewItem : CPCollectionViewItem
{
  // The implementation of CollectionViewItem#collectionView
  // doesn't return the collectionview, though I don't know why.
  // Therefore I'm using a separate way of getting at it.
  // TODO: make a test for this, try it with later versions of Cappuccino.
  ButtonCollectionView containingCollectionView;
}

- (void) setView: aButton
{
  [super setView: aButton];
  [aButton setTarget: self];
  [aButton setAction: @selector(click:)];
}

- (void) click: sender
{
  [containingCollectionView clickOn: self];
}

-(void) setContainingCollectionView: aCollectionView
{
  containingCollectionView = aCollectionView;
}

-(ButtonCollectionView) containingCollectionView
{
  return containingCollectionView;
}

- (void) refreshButtonTitle
{
  var title = [[self representedObject] name];
  if ([title isEqual: ""])
  {
    title = [[self containingCollectionView] defaultName];
  }
  [[self view] setTitle: title];
}

- (void) distinguishYourself
{
  [[self view] distinguishYourself]
}

- (void) sinkBackIntoObscurity
{
  [[self view] sinkBackIntoObscurity];
}


@end


@implementation ConformingButton : CPButton
{
  // I'd like to make buttons distinguished by changing their theme state,
  // but I can't make that work. So this variable is now unused.
  id originalThemeState;
  
  // I make buttons distinguished by setting them to be the default button. 
  // Since you can't ask a CPButton if it's default, I have its item remember.
  CPBoolean isDistinguished;
}

- (void)setRepresentedObject:(id)anObject
{
  // This is required by the CPCollectionView protocol.
}


- (void) distinguishYourself
{
  // TODO: figure out how this theme state stuff really works. This doesn't do it.
  // originalThemeState = [[self view] themeState];
  //   [self setThemeState: CPThemeStateDefault];
  [self setDefaultButton: YES];
  isDistinguished = YES;
}

- (void) sinkBackIntoObscurity
{
  [self setDefaultButton: NO];
  isDistinguished = NO;
  // [self setThemeState: originalThemeState];
}

- (CPBoolean) distinguished
{
  return isDistinguished;
}

/*
- (void) setThemeState: value
{
  alert("theme state for " + [[self representedObject] name] + " is " + originalThemeState);
  [[self view] setThemeState: value];
}
*/

@end
