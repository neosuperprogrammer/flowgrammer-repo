//
//  NEOCalendarView.h
//  Calendar Test
//
//  Created by Nam, SangWook on 13. 3. 27..
//  Copyright (c) 2013년 Nam, SangWook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

@interface NEOCalendarView : UIView

- (void)setDateComponent:(NSDateComponents *)dateComp;

@property (nonatomic) BiorhythmType biorhythmType;

@end
