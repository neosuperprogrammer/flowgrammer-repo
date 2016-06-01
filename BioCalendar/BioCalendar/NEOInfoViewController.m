//
//  NEOInfoViewController.m
//  BioCalendar
//
//  Created by Sangwook Nam on 13. 5. 20..
//  Copyright (c) 2013년 Sangwook Nam. All rights reserved.
//

#import "NEOInfoViewController.h"

@interface NEOInfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation NEOInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Information";
    
    
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(click:)];
    
    self.navigationItem.rightBarButtonItem = bar;
    
    
    _versionLabel.text = [NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)click:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidUnload {
    [self setVersionLabel:nil];
    [super viewDidUnload];
}
@end
