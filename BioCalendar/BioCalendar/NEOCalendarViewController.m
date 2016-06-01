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
#import "SelectPersonViewController.h"
#import "NEOCalloutView.h"
#import "PersonDatas.h"
#import "NEOInfoViewController.h"

@interface NEOCalendarViewController ()

@property (weak, nonatomic) UISegmentedControl *bioSeg;

@property (strong, nonatomic) NEOTitleView *titleView;
@property (strong, nonatomic) NEOCalendarView *prevCalendarView;
@property (strong, nonatomic) NEOCalendarView *nextCalendarView;
@property (strong, nonatomic) NEOCalendarView *currCalendarView;
@property (strong, nonatomic) NSDateComponents *currentDateComp;
@property (strong, nonatomic) NEOCalloutView *popOver;
@property (nonatomic) BiorhythmType biorhythmType;

@end

//test

#pragma mark -

@implementation NEOCalendarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _biorhythmType = physicalType;
        _popOver = [[NEOCalloutView alloc] initWithFrame:CGRectZero];
        
        
        [self setupLayout];
        
        self.title = [NSBundle mainBundle].infoDictionary[@"CFBundleDisplayName"];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self showCalendar];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style:UIBarButtonItemStylePlain target:nil action:nil];

}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:NO animated:animated];
    
    UIBarButtonItem *barBtnLeft = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"SelectPerson", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(action:)];
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UISegmentedControl *bioSeg = [[UISegmentedControl alloc] initWithItems:@[NSLocalizedString(@"Physical", @""), NSLocalizedString(@"Emotional", @""), NSLocalizedString(@"Intelligence", @"")]];
    _bioSeg = bioSeg;
    [_bioSeg addTarget:self action:@selector(segSelected:) forControlEvents:UIControlEventValueChanged];
    _bioSeg.segmentedControlStyle = UISegmentedControlStyleBar;
    [_bioSeg setSelectedSegmentIndex:_biorhythmType];
    
    UIBarButtonItem *segBarButton = [[UIBarButtonItem alloc] initWithCustomView:_bioSeg];
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [infoButton addTarget:self action:@selector(info:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *infoBarButton = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
    
    self.toolbarItems = @[barBtnLeft, flexible, segBarButton, flexible, infoBarButton];
    
    [self segSelected:_bioSeg];
    
    
    [_currCalendarView setDateComponent:self.currentDateComp];
    self.navigationItem.prompt = [[PersonDatas getInstance] getSelectedPersonInfo];
}

- (IBAction)info:(id)sender
{
    NEOInfoViewController *viewController = [[NEOInfoViewController alloc] initWithNibName:NSStringFromClass([NEOInfoViewController class]) bundle:nil];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    [navi setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:navi animated:YES completion:^{
        
    }];
}

#if __IPHONE_6_0 > __IPHONE_OS_VERSION_MIN_REQUIRED
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return interfaceOrientation == UIInterfaceOrientationPortrait;
}
#endif

#if __IPHONE_6_0 <= __IPHONE_OS_VERSION_MAX_ALLOWED
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
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

- (IBAction)segSelected:(id)sender
{
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    _biorhythmType = seg.selectedSegmentIndex;
    
    self.title = [NSString stringWithFormat:@"%@(%@)", [NSBundle mainBundle].infoDictionary[@"CFBundleDisplayName"], [seg titleForSegmentAtIndex:seg.selectedSegmentIndex]];
    
    [self changeBiorhythmType];
}

- (void)changeBiorhythmType
{
    _currCalendarView.biorhythmType = _biorhythmType;
    [_currCalendarView setDateComponent:_currCalendarView.dateComp];
}


- (IBAction)action:(id)sender
{
    SelectPersonViewController *controller = [[SelectPersonViewController alloc] initWithNibName:NSStringFromClass([SelectPersonViewController class]) bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self.navigationController setToolbarHidden:NO animated:animated];
//}

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
    
    __weak NEOCalloutView *popOver = _popOver;
    __weak NEOCalendarViewController *_self = self;
    
    [_currCalendarView setSelectDelegate:^(UIView *view, NSString *message) {
        popOver.title = message;
        
        CGRect clickRect = [view convertRect:view.bounds toView:_self.view];
        
        [popOver showPopover:CGPointMake(clickRect.origin.x + clickRect.size.width / 2, clickRect.origin.y + clickRect.size.height / 2)
                       inView:_self.view
                     animated:YES];
    }];
    
    
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
