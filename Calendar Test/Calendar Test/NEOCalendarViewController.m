//
//  NEOCalendarViewController.m
//  Calendar Test
//
//  Created by Nam, SangWook on 13. 3. 27..
//  Copyright (c) 2013년 Nam, SangWook. All rights reserved.
//

#import "NEOCalendarViewController.h"
#import "NEOTitleView.h"
#import "NEOCalendarView.h"
#import "Common.h"

@interface NEOCalendarViewController ()

@property (strong, nonatomic) NEOTitleView *titleView;
@property (strong, nonatomic) NEOCalendarView *prevCalendarView;
@property (strong, nonatomic) NEOCalendarView *nextCalendarView;
@property (strong, nonatomic) NEOCalendarView *currCalendarView;
@property (strong, nonatomic) NSDateComponents *currentDateComp;

@property (nonatomic) BiorhythmType biorhythmType;

@end

#pragma mark -

@implementation NEOCalendarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _biorhythmType = physicalType;
        [self setupLayout];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self showCalendar];
}

#if __IPHONE_6_0 > __IPHONE_OS_VERSION_MIN_REQUIRED
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}
#endif

#if __IPHONE_6_0 <= __IPHONE_OS_VERSION_MAX_ALLOWED
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
#endif

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self layoutFrame];
    
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self layoutFrame];
}

- (void)layoutFrame
{
    _titleView.frame = _titleView.frame;
    CGRect calendarRect = CGRectMake(0.0f, 40.0f, self.view.frame.size.width, self.view.frame.size.height - 40.0f);
    _prevCalendarView.frame = calendarRect;
    _nextCalendarView.frame = calendarRect;
    _currCalendarView.frame = calendarRect;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Custom Methods

- (void)setupLayout
{
    self.navigationItem.title = NSLocalizedString(@"test", @"test");
//    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([NEOTitleView class]) owner:self options:nil];
//    self.titleView = [views lastObject];
    self.titleView = [[NEOTitleView alloc] init];
    self.currCalendarView = [[NEOCalendarView alloc] initWithFrame:CGRectZero];
    self.nextCalendarView = [[NEOCalendarView alloc] initWithFrame:CGRectZero];
    self.prevCalendarView = [[NEOCalendarView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_titleView];
    [self.view addSubview:_prevCalendarView];
    [self.view addSubview:_nextCalendarView];
    [self.view addSubview:_currCalendarView];
    
    UISwipeGestureRecognizer *swipeL = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeL)];
    swipeL.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeL];
    
    UISwipeGestureRecognizer *swipeR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeR)];
    swipeR.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeR];
}

- (void)showCalendar
{
    NEOLog("test");
    
//    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
//    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents *dateComp = [cal components:unitFlags fromDate:[NSDate date]];
    
    NSDateComponents *dateComp = [NEODateUtil dateComponentFromDate:[NSDate date]];
    [self setCalendarDate:dateComp];
    
//    
//    NSDate *currentDate = [NSDate date];
//    NSDateComponents *dateComp = [NSDateComponents ]
//    _titleView.MonthLabel.text = currentDate;
}

- (void)setCalendarDate:(NSDateComponents *)dateComp
{
    _prevCalendarView.hidden = YES;
    _nextCalendarView.hidden = YES;
    
    _currCalendarView.biorhythmType = _biorhythmType;
    _prevCalendarView.biorhythmType = _biorhythmType;
    _nextCalendarView.biorhythmType = _biorhythmType;
    
    _currentDateComp = dateComp;
    
    _titleView.MonthLabel.text = [NSString stringWithFormat:@"%d", [dateComp month]];
    _titleView.yearLabel.text = [NSString stringWithFormat:@"%d", [dateComp year]];
    
    [_currCalendarView setDateComponent:dateComp];
    
    NSDateComponents *prevMonthDateComp = [NEODateUtil componentsByAddingMonth:-1 toComp:dateComp];
    NSDateComponents *nextMonthDateComp = [NEODateUtil componentsByAddingMonth:1 toComp:dateComp];
    
    [_prevCalendarView setDateComponent:prevMonthDateComp];
    [_nextCalendarView setDateComponent:nextMonthDateComp];
    

}


#pragma mark - UISwipeGesture Action
- (void)handleSwipeL
{
    NEOLog(@"handleSwipeL");
    
    NSDateComponents *newDateComp = [NEODateUtil componentsByAddingMonth:1 toComp:_currentDateComp];
    [self setCalendarDate:newDateComp];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:_currCalendarView cache:YES];
    [UIView commitAnimations];
}

- (void)handleSwipeR
{
    NEOLog(@"handleSwipeR");
    
    NSDateComponents *newDateComp = [NEODateUtil componentsByAddingMonth:-1 toComp:_currentDateComp];
    [self setCalendarDate:newDateComp];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:_currCalendarView cache:YES];
    [UIView commitAnimations];
}


@end
