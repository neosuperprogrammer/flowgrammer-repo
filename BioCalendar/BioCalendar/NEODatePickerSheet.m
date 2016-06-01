//
//  NEOActionSheet.m
//  UITest11
//
//  Created by Sangwook Nam on 13. 5. 16..
//  Copyright (c) 2013년 Sangwook Nam. All rights reserved.
//

#import "NEODatePickerSheet.h"

@interface NEODatePickerSheet ()

@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UIToolbar *mytoolbar;

@end

@implementation NEODatePickerSheet

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       self.datePicker = [[UIDatePicker alloc] init];
        [_datePicker setDatePickerMode:UIDatePickerModeDate];
        
        NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:[language isEqualToString:@"ko"] ? @"ko_KR" : @"en_US"];
        _datePicker.locale = locale;
        [self addSubview:_datePicker];
         
        self.mytoolbar = [[UIToolbar alloc] init];
        _mytoolbar.barStyle = UIBarStyleBlackTranslucent;
        
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
        
        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *barButton2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
        _mytoolbar.items = @[barButton, flexible, barButton2];
        
        [self addSubview:_mytoolbar];
    }
    return self;
}

- (IBAction)cancel:(id)sender
{
    [self dismissWithClickedButtonIndex:0 animated:YES];
    if(_cancel != nil) {
        _cancel();
    }
}

- (IBAction)done:(id)sender
{
    [self dismissWithClickedButtonIndex:0 animated:YES];
    if(_confirm != nil) {
        NSDate *date = _datePicker.date;
        _confirm(date);
    }
}

- (void)setFrame:(CGRect)frame
{
    _mytoolbar.frame = CGRectMake(0.0f, 0.0f, frame.size.width, 44.0f);
    
    CGRect pickerViewFrame = _datePicker.frame;
    pickerViewFrame.origin.y = _mytoolbar.frame.size.height;
    _datePicker.frame = pickerViewFrame;
    frame.size.height = _mytoolbar.frame.size.height + _datePicker.frame.size.height;
    [super setFrame:frame];
}

- (void)show:(UIView *)view
{
    [self showInView:view];
}

@end
