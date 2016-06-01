//
//  NEODayView.h
//  Calendar Test
//
//  Created by Nam, SangWook on 13. 3. 27..
//  Copyright (c) 2013년 Nam, SangWook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NEODayView : UIView
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UIButton *dayButton;

@property (copy, nonatomic) NSDateComponents *dateComp;
@property (nonatomic) BOOL isActiveMonth;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic) BOOL isToday;
@property (weak, nonatomic) IBOutlet UIView *todayView;
@end
