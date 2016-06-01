//
//  NEODateUtil.m
//  Calendar Test
//
//  Created by Nam, SangWook on 13. 3. 27..
//  Copyright (c) 2013년 Nam, SangWook. All rights reserved.
//

#import "NEODateUtil.h"
#import "Common.h"

@implementation NEODateUtil


static NSUInteger const commonFlags = NSYearCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;

+ (NSDateComponents *)dateComponentFromDate:(NSDate *)date
{
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return [cal components:commonFlags fromDate:date];
}


+ (NSDateComponents*)componentsByAddingDay:(NSInteger)addingDay toComp:(NSDateComponents *)prevDateComp
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *prevDate = [calendar dateFromComponents:prevDateComp];
	NSDateComponents* addingDayComp = [[NSDateComponents alloc] init];
	[addingDayComp setDay:addingDay];
    NSDate *newDate = [calendar dateByAddingComponents:addingDayComp toDate:prevDate options:0];
    return [calendar components:commonFlags fromDate:newDate];
}

+ (NSDateComponents*)componentsByAddingMonth:(NSInteger)addingMonth toComp:(NSDateComponents *)prevDateComp
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *prevDate = [calendar dateFromComponents:prevDateComp];
	NSDateComponents* addingMonthComp = [[NSDateComponents alloc] init];
	[addingMonthComp setMonth:addingMonth];
    NSDate *newDate = [calendar dateByAddingComponents:addingMonthComp toDate:prevDate options:0];
    return [calendar components:commonFlags fromDate:newDate];
}

+ (void)printDayComp:(NSDateComponents *)aDateComp withTag:(NSString *)tag
{
    NEOLog(@"%@ : %04d/%02d/%02d", tag, aDateComp.year, aDateComp.month, aDateComp.day);
}

@end
