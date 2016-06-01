//
//  NEOTitleView.m
//  Calendar Test
//
//  Created by Nam, SangWook on 13. 3. 27..
//  Copyright (c) 2013년 Nam, SangWook. All rights reserved.
//

#import "NEOTitleView.h"

@interface NEOTitleView ()


@end


@implementation NEOTitleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        self = [views lastObject];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        
    }
    return self;
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//    // Drawing code
//}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    float width = frame.size.width / 7;
    float left = 0.0f;
    for(UILabel *day in _dayView.subviews) {
        day.frame = CGRectMake(left, 0, width, _dayView.frame.size.height);
        left += width;
    }
}

@end
