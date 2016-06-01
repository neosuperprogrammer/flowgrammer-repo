//
//  NEODayView.m
//  Calendar Test
//
//  Created by Nam, SangWook on 13. 3. 27..
//  Copyright (c) 2013년 Nam, SangWook. All rights reserved.
//

#import "NEODayView.h"

@interface NEODayView ()




@end


@implementation NEODayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        self = [views lastObject];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    if(_isToday) {
//        CGContextRef context = UIGraphicsGetCurrentContext();
////        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:1.0f].CGColor);
//        CGContextSetLineWidth(context, [UIScreen mainScreen].scale * 6);
//        CGContextSetRGBStrokeColor(context, 0.0f, 0.0f, 1.0f, 0.7f);
////        CGContextSetRGBFillColor(context, 0.0f, 0.0f, 1.0f, 0.5f);
//        CGContextStrokeRect(context, CGRectInset(rect, [UIScreen mainScreen].scale * 2, [UIScreen mainScreen].scale * 2));
////        CGContextFillRect(context, rect);
////        CGContextRelease(context);
    }
}


- (void)setDateComp:(NSDateComponents *)dateComp
{
    _dateComp = [dateComp copy];
    self.dayLabel.text = [NSString stringWithFormat:@"%d", _dateComp.day];
    if(_dateComp.weekday == 1) {
        self.dayLabel.textColor = [UIColor redColor];
    }
    else if(_dateComp.weekday == 7) {
        self.dayLabel.textColor = [UIColor blueColor];
    }
    else {
        self.dayLabel.textColor = [UIColor blackColor];
    }
}

- (void)setIsActiveMonth:(BOOL)isActiveMonth
{
    if(isActiveMonth) {
        self.dayLabel.alpha = 1.0f;
    }
    else {
        self.dayLabel.alpha = 0.3f;
    }
    
}


@end
