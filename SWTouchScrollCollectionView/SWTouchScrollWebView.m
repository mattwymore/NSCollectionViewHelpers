//
//  SWTouchScrollWebView.m
//  CurrentScience
//
//  Created by Spencer Williams on 12/17/14.
//  Copyright (c) 2014 Uncorked Studios. All rights reserved.
//

#import "SWTouchScrollWebView.h"
#import "SWTouchScrollView.h"

@interface SWTouchScrollWebView() {
    NSPoint lastPoint;
    NSPoint scrollToPoint;
}
@property (nonatomic, strong) SWTouchScrollView *touchScroller;
@end

@implementation SWTouchScrollWebView

- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self commonInit];
    }
    return self;
}
- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        [self commonInit];
    }
    return self;
}
- (instancetype)initWithFrame:(NSRect)frame frameName:(NSString *)frameName groupName:(NSString *)groupName {
    if (self = [super initWithFrame:frame frameName:frameName groupName:groupName]) {
        [self commonInit];
    }
    return self;
}
- (void)commonInit {
    [self setUIDelegate:self];
    [self setEditingDelegate:self];
    _pointSmootherLength = 25;
    _scrollScaling = CGPointMake(1, 1);
    _touchScrollDirection = SWTouchScrollDirectionVertical | SWTouchScrollDirectionHorizontal;
    
    [self reinitializeTouchScroller];
    [self updateTouchScrollerContentSize];
}

- (NSScrollView *)webScrollView {
    return ((NSScrollView *)((WebFrameView *)self.subviews[0]).subviews[0]);
}

- (void)setScrollerKnobStyle:(NSScrollerKnobStyle)knobStyle
{
    [self.webScrollView setScrollerKnobStyle:knobStyle];
}

#pragma mark - WebUIDelegate and WebEditingDelegate Protocols

- (NSArray *)webView:(WebView *)sender contextMenuItemsForElement:(NSDictionary *)element
    defaultMenuItems:(NSArray *)defaultMenuItems
{
    // disable right-click context menu
    return nil;
}

- (BOOL)webView:(WebView *)webView shouldChangeSelectedDOMRange:(DOMRange *)currentRange
     toDOMRange:(DOMRange *)proposedRange
       affinity:(NSSelectionAffinity)selectionAffinity
 stillSelecting:(BOOL)flag
{
    // disable text selection
    return NO;
}

#pragma mark - Touch Scroll stuff

- (void)reinitializeTouchScroller
{
    NSLog(@"[TSWV] reinit touchScroller");
    _touchScroller = [[SWTouchScrollView alloc] initWithFrame:NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height)];
    [_touchScroller setDrawsBackground:NO];
    [self addSubview:_touchScroller];
    [_touchScroller setScrollDelegate:self];
    [_touchScroller setTouchScrollDirection:self.touchScrollDirection];
    [_touchScroller newPointSmootherWithLength:self.pointSmootherLength];
    [_touchScroller setScrollScaling:self.scrollScaling];
    [_touchScroller initializeTouchScrollable];
    [_touchScroller setScrollingView:self.webScrollView.contentView];
}
- (void)updateTouchScrollerContentSize
{
    NSClipView *newContentView = [[NSClipView alloc] initWithFrame:self.webScrollView.contentView.frame];
    [newContentView setDrawsBackground:NO];
    [_touchScroller setContentView:newContentView];
}
- (SWTouchScrollView *)touchScroller
{
    if (_touchScroller == nil) {
        [self reinitializeTouchScroller];
    }
    [self updateTouchScrollerContentSize];
    return _touchScroller;
}

- (void)setFrame:(NSRect)frame
{
    [super setFrame:frame];
    [self.touchScroller setFrameSize:frame.size];
}

- (void)setPointSmootherLength:(NSInteger)pointSmootherLength
{
    _pointSmootherLength = pointSmootherLength;
    [self reinitializeTouchScroller];
}

- (void)setScrollScaling:(CGPoint)scrollScaling
{
    _scrollScaling = scrollScaling;
    [self reinitializeTouchScroller];
}

- (void)setTouchScrollDirection:(SWTouchScrollDirection)touchScrollDirection
{
    _touchScrollDirection = touchScrollDirection;
    [self reinitializeTouchScroller];
}

@end
