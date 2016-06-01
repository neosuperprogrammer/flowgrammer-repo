//
//  NEOCalloutView.h
//  UITest7
//
//  Created by Sangwook Nam on 13. 5. 13..
//  Copyright (c) 2013년 Nam, SangWook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NEOCalloutView : UIView

@property (copy, nonatomic) NSString *title;

- (void)showPopover:(CGPoint)anchorPoint inView:(UIView *)superView animated:(BOOL)animated;

@end
