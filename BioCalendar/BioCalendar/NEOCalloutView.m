//
//  NEOCalloutView.m
//  UITest7
//
//  Created by Sangwook Nam on 13. 5. 13..
//  Copyright (c) 2013년 Nam, SangWook. All rights reserved.
//

#import "NEOCalloutView.h"
#import "Common.h"

#define kPinPointWidth  (10.0f)
#define KPinPointHeight (10.0f)
#define kRadius         (10.0f)
#define kMinWidth       (100.0f)
#define kMinHeight      (40.0f)
#define kPadding        (5.0f)


@interface NEOCalloutView ()

//@property (copy, nonatomic) NSString *message;
@property (strong, nonatomic) id target;
@property (nonatomic) SEL action;
@property (nonatomic) CGPoint anchor;
@property (nonatomic) CGRect popoverRect;
@property (strong, nonatomic) UIFont *font;
@property (nonatomic) BOOL isOverToPinPoint;

@end


@implementation NEOCalloutView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [self addGestureRecognizer:gesture];
        
        self.font = [UIFont boldSystemFontOfSize:14.0f];
        self.backgroundColor = [UIColor clearColor];
        
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    [self setNeedsDisplay];
}

- (IBAction)tapped:(id)sender
{
    [self hide:YES];
    if([_target respondsToSelector:_action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [_target performSelector:_action];
#pragma clang diagnostic pop
    }
}

- (void)addTaget:(id)target action:(SEL)selector
{
    _target = target;
    _action = selector;
}

- (void)showPopover:(CGPoint)anchorPoint inView:(UIView *)superView animated:(BOOL)animated
{
    if(self.superview != nil) {
        [self removeFromSuperview];
    }
    [superView addSubview:self];
    
    CGSize size = [_title sizeWithFont:_font constrainedToSize:superView.bounds.size lineBreakMode:NSLineBreakByTruncatingTail];
    size.width += kRadius *2;
    size.height += kRadius*2;
    if(size.width < kMinWidth) {
        size.width = kMinWidth;
    }
    if(size.height < kMinHeight) {
        size.height = kMinHeight;
    }
    
    _isOverToPinPoint = YES;
    CGFloat startX = anchorPoint.x - size.width / 2;
    CGFloat startY = anchorPoint.y - size.height - KPinPointHeight;
    
    _anchor = anchorPoint;
    
    
    if(startY < superView.bounds.origin.y) {
        _isOverToPinPoint = NO;
        startY = anchorPoint.y + KPinPointHeight;
    }
    
    if(startX < superView.bounds.origin.x) {
        startX = superView.bounds.origin.x + kPadding;
    }
    else if(startX + size.width > superView.bounds.origin.x + superView.bounds.size.width) {
        startX = superView.bounds.origin.x + superView.bounds.size.width - ( size.width + kPadding);
    }
    
    if(_anchor.x < startX + kRadius + kPadding) {
        _anchor.x = startX + kRadius + kPadding;
    }
    else if(_anchor.x > startX + size.width + kRadius + kPadding) {
        _anchor.x = startX + size.width + kRadius + kPadding;
    }

    
    CGRect frameRect = CGRectMake(startX, startY - (_isOverToPinPoint ? 0 : KPinPointHeight), size.width, size.height + KPinPointHeight);
    
    if(animated) {
        
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        self.frame = frameRect;
        _popoverRect = frameRect;
        _popoverRect.origin.x = 0;
        _popoverRect.origin.y = 0;
        _anchor.x = _anchor.x - self.frame.origin.x;
        _anchor.y = _anchor.y - self.frame.origin.y;
        
        self.alpha = 0.3f;
        self.transform = CGAffineTransformMakeScale(0.3f, 0.3f);
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        [UIView setAnimationDuration:0.12f];
        
        self.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
        self.alpha = 1.0f;
        [UIView commitAnimations];
    }
    else {
        self.frame = frameRect;
    }
    
}


- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{

    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinallyDidStop:finished:context:)];
    [UIView setAnimationDuration:0.12f];
    
    self.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    self.alpha = 1.0f;
    [UIView commitAnimations];
}

- (void)animationFinallyDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
//    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    
    _popoverRect.size.height -= KPinPointHeight;
    if(!_isOverToPinPoint) {
        _popoverRect.origin.y += KPinPointHeight;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGMutablePathRef path = CGPathCreateMutable();

    CGFloat anchorX = _anchor.x;
    CGFloat anchorY = _anchor.y;

    CGFloat startX = _popoverRect.origin.x;
    CGFloat startY = _popoverRect.origin.y;
    CGFloat endX = _popoverRect.origin.x + _popoverRect.size.width;
    CGFloat endY = _popoverRect.origin.y + _popoverRect.size.height;
//    CGRect popoverRect = CGRectMake(startX, startY, size.width, size.height + KPinPointHeight);
    
    
    CGPathMoveToPoint(path, NULL, anchorX, anchorY);
    
    if(_isOverToPinPoint) {
        CGPathAddLineToPoint(path, NULL, anchorX + kPinPointWidth / 2 , anchorY - KPinPointHeight);
        CGPathAddArcToPoint(path, NULL, endX, endY, endX, endY - kRadius, kRadius);
        CGPathAddArcToPoint(path, NULL, endX, startY, endX - kRadius, startY, kRadius);
        CGPathAddArcToPoint(path, NULL, startX, startY, startX, startY + kRadius, kRadius);
        CGPathAddArcToPoint(path, NULL, startX, endY, startX + kRadius, endY, kRadius);
        CGPathAddLineToPoint(path, NULL, anchorX - kPinPointWidth / 2 , anchorY - KPinPointHeight);
    }
    else {
        CGPathAddLineToPoint(path, NULL, anchorX + kPinPointWidth / 2 , anchorY + KPinPointHeight);
        CGPathAddArcToPoint(path, NULL, endX, startY, endX, startY + kRadius, kRadius);
        CGPathAddArcToPoint(path, NULL, endX, endY, endX - kRadius, endY, kRadius);
        CGPathAddArcToPoint(path, NULL, startX, endY, startX, endY - kRadius, kRadius);
        CGPathAddArcToPoint(path, NULL, startX, startY, startX + kRadius, startY, kRadius);
        CGPathAddLineToPoint(path, NULL, anchorX - kPinPointWidth / 2 , anchorY + KPinPointHeight);
    }
    CGPathCloseSubpath(path);
    
    
    // Draw shadow
    //	CGContextAddPath(context, path);
    //    CGContextStrokePath(context);
    CGContextAddPath(context, path);
    //    CGContextFillPath(context);
    
    
    CGContextSetRGBStrokeColor(context, 0.0f, 0.0f, 0.0f, 1.0f);
//    CGContextSetRGBFillColor(context, 0.0f, 0.0f, 0.0f, 0.5f);
    CGContextSetLineWidth(context, [[UIScreen mainScreen] scale]);
    
    
    CGContextSaveGState(context);
	CGContextSetShadow(context, CGSizeMake(0, 3), 5);
	CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 0.9);
	CGContextFillPath(context);
    CGContextRestoreGState(context);
    
    
	// Draw clipped background gradient
    
    CGContextSaveGState(context);
    
	CGContextAddPath(context, path);
	CGContextClip(context);
    

    [NEOCalloutView drawLinearGradient:context drawBounds:self.bounds colorRef:[UIColor blackColor].CGColor];
    
    CGContextRestoreGState(context);
    
    
    CGContextSetRGBStrokeColor(context, 0.0f, 0.0f, 0.0f, 1.0f);
	CGContextAddPath(context, path);
    CGContextDrawPath(context, kCGPathStroke);
    
    
    CGPathRelease(path);
    
    
    UIColor *textColor = [UIColor whiteColor];
    [textColor set];
    
    CGRect textRect = CGRectMake(_popoverRect.origin.x + kRadius,
                                 _popoverRect.origin.y + kRadius,
                                 _popoverRect.size.width - kRadius * 2,
                                 _popoverRect.size.height - kRadius * 2);
    
    
    [_title drawInRect:textRect
              withFont:_font
         lineBreakMode:NSLineBreakByTruncatingTail
             alignment:NSTextAlignmentLeft];
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self hide:YES];
//}

- (void)hide:(BOOL)animated
{
    if(self.superview != nil) {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.15f];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(hideAnimationDidStop:finished:context:)];
        self.alpha = 0.0f;
        [UIView commitAnimations];

    }
}

- (void)hideAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    [self removeFromSuperview];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

+ (void)drawLinearGradient:(CGContextRef)context drawBounds:(CGRect)drawBounds colorRef:(CGColorRef)color
{
    CGFloat bubbleMiddle = 0.5;
	
	CGGradientRef myGradient;
	CGColorSpaceRef myColorSpace;
	size_t locationCount = 5;
	CGFloat locationList[] = {0.0, bubbleMiddle-0.03, bubbleMiddle, bubbleMiddle+0.03, 1.0};
    
	CGFloat colourHL = 0.25;
	
	CGFloat red;
	CGFloat green;
	CGFloat blue;
	CGFloat alpha;
	int numComponents = CGColorGetNumberOfComponents(color);
	const CGFloat *components = CGColorGetComponents(color);
	if (numComponents == 2) {
		red = components[0];
		green = components[0];
		blue = components[0];
		alpha = components[1];
	}
	else {
		red = components[0];
		green = components[1];
		blue = components[2];
		alpha = components[3];
	}
	CGFloat colorList[] = {
		//red, green, blue, alpha
		red*1.16+colourHL*2, green*1.16+colourHL*2, blue*1.16+colourHL*2, alpha,
		red*1.16+colourHL, green*1.16+colourHL, blue*1.16+colourHL, alpha,
		red*1.08+colourHL, green*1.08+colourHL, blue*1.08+colourHL, alpha,
		red     +colourHL, green     +colourHL, blue     +colourHL, alpha,
		red,                green,              blue,               alpha
	};

	myColorSpace = CGColorSpaceCreateDeviceRGB();
	myGradient = CGGradientCreateWithColorComponents(myColorSpace, colorList, locationList, locationCount);
	CGPoint startPoint, endPoint;
	startPoint.x = CGRectGetMidX(drawBounds);
	startPoint.y = CGRectGetMinY(drawBounds);
	endPoint.x = CGRectGetMidX(drawBounds);
	endPoint.y = CGRectGetMaxY(drawBounds);
	
	CGContextDrawLinearGradient(context, myGradient, startPoint, endPoint,0);
	CGGradientRelease(myGradient);
	CGColorSpaceRelease(myColorSpace);
}

@end
