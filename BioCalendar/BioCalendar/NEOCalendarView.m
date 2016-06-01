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
#import "PersonDatas.h"
#import <QuartzCore/QuartzCore.h>

#define TAG_BASE        (1000)

@interface NEOCalendarView ()


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
    
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents *birthDayComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
//    birthDayComp.year = 1973;
//    birthDayComp.month = 2;
//    birthDayComp.day = 4;
    
    
    NSDateComponents *birthDayComp = [[PersonDatas getInstance] getPersonBirthdayDateComp];
    
    BOOL isBirthdaySelected = birthDayComp != nil;
    
    if(isBirthdaySelected) {
        [_bio recalcBiorhythmData:birthDayComp andCurrentDate:dateComp];
    }
    
    NSDate *now = [NSDate date];
    NSDateComponents *nowDateComp = [NEODateUtil dateComponentFromDate:now];
    
    int dayIndex = 0;
    
    for(int i = 0; i<6 * 7; i++) {
        NEODayView *day = (NEODayView *)[self viewWithTag:TAG_BASE + i];
        
        day.dateComp = [NEODateUtil componentsByAddingDay:i toComp:firstDayCompOfFirstWeek];
        

        
        
        if(day.dateComp.month == _dateComp.month) {
            day.isActiveMonth = YES;

            if(isBirthdaySelected) {
                double biorhythm = [_bio getBiorhythm:dayIndex++ ofType:_biorhythmType];
                float green = 1.0f - ( ( biorhythm + 100.0 ) / 200.0 );
                day.bgView.backgroundColor = [UIColor colorWithRed:green green:green blue:green alpha:0.5f];
            }
            else {
                day.bgView.backgroundColor = [UIColor whiteColor];
            }
        }
        else {
            day.isActiveMonth = NO;
            day.bgView.backgroundColor = [UIColor whiteColor];
            
        }
        
        if(day.dateComp.month == nowDateComp.month && day.dateComp.day == nowDateComp.day) {
            day.todayView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:0.5f];
            day.todayView.hidden = NO;
            day.todayView.layer.cornerRadius = day.todayView.frame.size.width/2;
            day.todayView.layer.borderWidth = 1.f;
            day.todayView.layer.borderColor = [UIColor colorWithWhite:0.f alpha:0.1176470588f].CGColor;
            day.isToday = YES;
        }
        else {
            day.todayView.hidden = YES;
            day.isToday = NO;
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
    
    if(dayView.dateComp.month == _dateComp.month) {
        NSInteger index = dayView.dateComp.day - 1;
        double physical = [_bio getBiorhythm:index ofType:physicalType];
        double emotion = [_bio getBiorhythm:index ofType:emotionType];
        double intelligence = [_bio getBiorhythm:index ofType:intelligenceType];
        NSString *message = [NSString stringWithFormat:@"%@ : %.2f\n%@ : %.2f\n%@ : %.2f",
                             NSLocalizedString(@"Physical", @""), physical,
                             NSLocalizedString(@"Emotional", @""), emotion,
                             NSLocalizedString(@"Intelligence", @""), intelligence
                             ];
        
        if(_selectDelegate != nil) {
            _selectDelegate(dayView, message);
        }

    }
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
