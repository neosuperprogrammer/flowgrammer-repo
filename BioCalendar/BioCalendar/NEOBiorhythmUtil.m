//
//  NEOBiorhythmUtil.m
//  Calendar Test
//
//  Created by Nam, SangWook on 13. 4. 22..
//  Copyright (c) 2013년 Nam, SangWook. All rights reserved.
//

#import "NEOBiorhythmUtil.h"

#define MAX_BIORHYTHMDATATYPE   (3)
#define SECONDS_PER_DAY         (24 * 60 * 60)
#define PI                      (3.141592653589793238467)

@interface NEOBiorhythmUtil () {
    double _biorhythmData[31][MAX_BIORHYTHMDATATYPE];
}
@end


@implementation NEOBiorhythmUtil

- (void)recalcBiorhythmData:(NSDateComponents *)bithDate andCurrentDate:(NSDateComponents *)currentDate
{
    NSDateComponents *firstDateComp = [[NSDateComponents alloc] init];
    [firstDateComp setYear:[currentDate year]];
    [firstDateComp setMonth:[currentDate month]];
    [firstDateComp setDay:1];
    
    
    NSDate *firstDate = [[NSCalendar currentCalendar] dateFromComponents:firstDateComp];
    NSDate *birthDay = [[NSCalendar currentCalendar] dateFromComponents:bithDate];
    
    NSTimeInterval interval = [firstDate timeIntervalSinceDate:birthDay];
    double daysSinceBirthDay = ceil(fabs(interval) / SECONDS_PER_DAY);
    
    
    static const double bioPeriod[MAX_BIORHYTHMDATATYPE] = {
        23.0, 28.0, 33.0        // 신체, 감성, 지성
    };
    
    for(int i = 0 ; i < 31 ; i++) {
        for(int j = 0 ; j < MAX_BIORHYTHMDATATYPE ; j++) {
            _biorhythmData[i][j] = sin((daysSinceBirthDay / bioPeriod[j]) * 2 * PI) * 100;
        }
        daysSinceBirthDay += 1.0;
    }
}

- (double)getBiorhythm:(NSUInteger)day ofType:(BiorhythmType)type
{
    return _biorhythmData[day][type];
}

@end
