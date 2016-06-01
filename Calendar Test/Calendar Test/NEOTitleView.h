//
//  NEOTitleView.h
//  Calendar Test
//
//  Created by Nam, SangWook on 13. 3. 27..
//  Copyright (c) 2013년 Nam, SangWook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NEOTitleView : UIView

@property (weak, nonatomic) IBOutlet UILabel *MonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;

@property (weak, nonatomic) IBOutlet UIView *dayView;
@end
