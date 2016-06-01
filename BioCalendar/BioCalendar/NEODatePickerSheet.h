//
//  NEOActionSheet.h
//  UITest11
//
//  Created by Sangwook Nam on 13. 5. 16..
//  Copyright (c) 2013년 Sangwook Nam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NEODatePickerSheet : UIActionSheet

- (void)show:(UIView *)view;

@property (copy, nonatomic) void (^cancel)(void);
@property (copy, nonatomic) void (^confirm)(NSDate *);

@end
