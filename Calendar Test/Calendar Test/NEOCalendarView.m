//
//  NEOCalendarView.m
//  Calendar Test
//
//  Created by Nam, SangWook on 13. 3. 27..
//  Copyright (c) 2013년 Nam, SangWook. All rights reserved.
//

#import "NEOCalendarView.h"
#import "NEODayView.h"
#import "Common.h"
#import "NEOBiorhythmUtil.h"

#define TAG_BASE        (1000)

@interface NEOCalendarView ()

@property (copy, nonatomic) NSDateComponents *dateComp;
@property (strong, nonatomic) NEOBiorhythmUtil *bio;

@end


@implementation NEOCalendarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _bio = [NEOBiorhythmUtil new];
        [self setupLayout];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void)setupLayout
{
    self.backgroundColor = [UIColor clearColor];
//    UILabel *label = [[UILabel alloc] init];
//    label.backgroundColor = [UIColor redColor];
//    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    
//    [self addSubview:label];
    
    [self setupDayLayout];
//    [self setDateComponent:[NEODateUtil dateComponentFromDate:[NSDate date]]];

}

- (void)setDateComponent:(NSDateComponents *)dateComp
{
    self.dateComp = dateComp;
    NSDateComponents *firstDayCompOfCurrentMonth = [NEODateUtil componentsByAddingDay:-(_dateComp.day - 1) toComp:_dateComp];
//    NSDateComponents *lastDayCompOfPrevMonth = [NEODateUtil componentsByAddingDay:-1 toComp:firstDayCompOfCurrentMonth];
//    NSDateComponents *firstDayCompOfNextMonth = [NEODateUtil componentsByAddingMonth:1 toComp:firstDayCompOfCurrentMonth];
//    NSDateComponents *lastDayCompOfCurrentMonth = [NEODateUtil componentsByAddingDay:-1 toComp:firstDayCompOfNextMonth];
    
    
    NSDateComponents *firstDayCompOfFirstWeek = [NEODateUtil componentsByAddingDay:-([firstDayCompOfCurrentMonth weekday] - 1) toComp:firstDayCompOfCurrentMonth];
    
//    NSDateComponents *lastDayCompOfLastWeek = [NEODateUtil componentsByAddingDay:(7-[lastDayCompOfCurrentMonth weekday]) toComp:lastDayCompOfCurrentMonth];
//    
//    [NEODateUtil printDayComp:_dateComp withTag:@"current day"];
//    [NEODateUtil printDayComp:firstDayCompOfCurrentMonth withTag:@"fisrt day of current month"];
//    [NEODateUtil printDayComp:lastDayCompOfCurrentMonth withTag:@"last day of current month"];
//    [NEODateUtil printDayComp:firstDayCompOfFirstWeek withTag:@"first day of first week"];
//    [NEODateUtil printDayComp:lastDayCompOfLastWeek withTag:@"last day of last week"];

    
//    NSInteger firstWeekDay = [firstDayCompOfCurrentMonth weekday] - 1;
//    NSInteger firstDayOfFirstWeek = [firstDayCompOfFirstWeek day];
//    NSInteger lastDayOfCurrentMonth = [lastDayCompOfCurrentMonth day];
//    
//    NSInteger dayOfCurrentMonth = 1;
//    NSInteger dayOfNextMonth = 1;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *birthDayComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    birthDayComp.year = 1973;
    birthDayComp.month = 2;
    birthDayComp.day = 4;
        
    [_bio recalcBiorhythmData:birthDayComp andCurrentDate:dateComp];
    
    
    for(int i = 0; i<6 * 7; i++) {
        NEODayView *day = (NEODayView *)[self viewWithTag:TAG_BASE + i];
        
        day.dateComp = [NEODateUtil componentsByAddingDay:i toComp:firstDayCompOfFirstWeek];
        if(day.dateComp.month == _dateComp.month) {
            day.isActiveMonth = YES;
            double biorhythm = [_bio getBiorhythm:i ofType:_biorhythmType];
            float green = ( ( biorhythm + 100.0 ) / 200.0 );
            day.backgroundColor = [UIColor colorWithRed:green green:green blue:green alpha:green];
        }
        else {
            day.isActiveMonth = NO;
            day.backgroundColor = [UIColor whiteColor];
            
        }
//        if(i%7 == 0) {
//            [day.dayLabel setTextColor:[UIColor redColor]];
//        }
//        else if(i%7 == 6) {
//            [day.dayLabel setTextColor:[UIColor blueColor]];
//        }
//        if(i < firstWeekDay) {
//            day.dayLabel.text = [NSString stringWithFormat:@"%d", firstDayOfFirstWeek++];
//            day.dayLabel.alpha = 0.3f;
//            continue;
//        }
//        if(dayOfCurrentMonth > lastDayOfCurrentMonth) {
//            day.dayLabel.text = [NSString stringWithFormat:@"%d", dayOfNextMonth++];
//            day.dayLabel.alpha = 0.3f;
//            continue;
//        }
//        day.dayLabel.text = [NSString stringWithFormat:@"%d", dayOfCurrentMonth++];
    }
    
}


- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
//     self.backgroundColor = [UIColor redColor];
//    
//    UILabel *label = [self.subviews lastObject];
//    label.frame = frame;
    [self setupDayLayout:frame];
    
}


- (void)setupDayLayout
{
    for(int i = 0; i<6 * 7; i++) {
        NEODayView *day = [[NEODayView alloc] init];
        day.dayLabel.font = [UIFont systemFontOfSize:15.0f];
        [day.dayButton addTarget:self action:@selector(daySelected:) forControlEvents:UIControlEventTouchUpInside];
        day.tag = TAG_BASE + i;
        [self addSubview:day];
    }
}

- (IBAction)daySelected:(id)sender
{
    UIButton *dayButton = (UIButton *)sender;
    NEODayView *dayView = (NEODayView *)dayButton.superview;
    
    NEOLog(@"day : %d is selected", dayView.dateComp.day);
}

- (void)setupDayLayout:(CGRect)frame
{
    float width = frame.size.width / 7;
    float height = frame.size.height / 6;
    float left = 0.0f;
    float top = 0.0f;
    int index = 0;
    for(NEODayView *day in self.subviews) {
        day.frame = CGRectMake(left, top, width, height);
        left += width;
        index++;
        if(index%7 == 0) {
            top += height;
            left = 0.0f;
        }
    }
    
    
    
    
    
}


@end
