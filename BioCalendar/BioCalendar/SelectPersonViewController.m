//
//  SelectPersonViewController.m
//  UITest
//
//  Created by Sangwook Nam on 13. 5. 10..
//  Copyright (c) 2013년 Nam, SangWook. All rights reserved.
//

#import "SelectPersonViewController.h"
#import "RegisterPersonViewController.h"

#import "PersonDatas.h"
#import "PersonDatas.h"

@interface SelectPersonViewController () < UITableViewDataSource, UITableViewDelegate > {
    PersonDatas *_personDatas;
}


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SelectPersonViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _personDatas = [PersonDatas getInstance];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = NSLocalizedString(@"SelectPerson", "");
    
    
    UIBarButtonItem *barBtnLeft = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"RegisterPerson", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(action:)];
    self.toolbarItems = @[barBtnLeft];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editAction:)];
//    self.navigationItem.leftBarButtonItem = editButton;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (IBAction)editAction:(id)sender
{
    
    [self.tableView setEditing:!self.tableView.isEditing animated:YES];

}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    [self.tableView setEditing:editing animated:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:NO animated:animated];

    
    [_tableView reloadData];
}

- (IBAction)action:(id)sender
{
    RegisterPersonViewController *viewController = [[RegisterPersonViewController alloc] initWithNibName:NSStringFromClass([RegisterPersonViewController class]) bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark - Table View Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_personDatas getPersonCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PersonCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [_personDatas getPersonName:indexPath.row];
    if([[PersonDatas getInstance] getSelectedIndex] == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.detailTextLabel.text = [_personDatas getPersonBirthday:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger selectedIndex = indexPath.row;
    [[PersonDatas getInstance] setSelectedIndex:selectedIndex];
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    NSInteger prevSelectedIndex = [[PersonDatas getInstance] getSelectedIndex];
    if(prevSelectedIndex >= 0) {
        cell = [self tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:prevSelectedIndex inSection:0]];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView reloadData];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_personDatas deletePerson:indexPath.row];
        [_personDatas savePersonData];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    id personData = [_personDatas getPersonData:fromIndexPath.row];
    
    [_personDatas deletePerson:fromIndexPath.row];
    [_personDatas insertObject:personData atIndex:toIndexPath.row];
    [_personDatas savePersonData];
    
//    NSDate *fromDate = _objects[fromIndexPath.row];
//    [_objects insertObject:fromDate atIndex:toIndexPath.row + 1];
//    [_objects removeObjectAtIndex:fromIndexPath.row];
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
