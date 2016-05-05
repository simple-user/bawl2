//
//  HistoryViewController.m
//  bawl2
//
//  Created by Admin on 04.05.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "HistoryViewController.h"
#import "User.h"
#import "CurrentItems.h"
#import "NetworkDataSorce.h"
#import "Constants.h"
#import "HistoryCell.h"
#import "ProfileViewController.h"

@interface HistoryViewController () <HistoryCellDelegate>

@property (strong, nonatomic) Issue *issue;
@property (strong, nonatomic) NSArray<User*> *users;
@property (strong, nonatomic) id <DataSorceProtocol> datasorce;


@property(strong, nonatomic) ProfileImageBox *profileImageBox;
@end

@implementation HistoryViewController


#pragma mark - Lasy instantiation

-(id <DataSorceProtocol>)datasorce
{
    if (_datasorce==nil)
    {
        _datasorce = [[NetworkDataSorce alloc] init];
    }
    return _datasorce;
}

-(ProfileImageBox*)profileImageBox
{
    if (_profileImageBox==nil)
    {
        _profileImageBox = [[ProfileImageBox alloc] init];
    }
    return _profileImageBox;
}

#pragma mark - Init / Load / Apper

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.issue = [CurrentItems sharedItems].issue;
    [self.datasorce requestAllUsers:^(NSArray<User *> *users, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(users!=nil)
            {
                self.users = users;
                [self.tableView reloadData];
            }
            
        });
    }];
    UINib *myNib = [UINib nibWithNibName:CustomCellHistoryCellXib bundle:nil];
    [self.tableView registerNib:myNib forCellReuseIdentifier:CustomCellHistoryCell];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.issue.historyActions count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellHistoryCell forIndexPath:indexPath];
    cell.contentView.userInteractionEnabled = NO;
    IssueHistoryAction *historyAction = [self.issue.historyActions objectAtIndex:indexPath.row];
    User *user = [self userById:historyAction.userId.integerValue];
    cell.actionText.text = historyAction.action;
    cell.stringDate.text = historyAction.stringDate;
    
    if(user== nil)
    {
        cell.fullName.text = @"update info...";
        cell.login.text = nil;
    }
    else
    {
        cell.fullName.text = user.name;
        cell.login.text = user.login;
    }
    
    cell.indexForButton = indexPath.row;
    cell.delegate = self;

    CGFloat width = cell.bounds.size.width; // it will be different on different devices
    [cell.actionText.widthAnchor constraintEqualToConstant:width/3].active=YES;
    [cell.stringDate.widthAnchor constraintEqualToConstant:width/3].active=YES;
    [cell.fullName.widthAnchor constraintEqualToConstant:width/3].active=YES;
    
    return cell;
}

-(User*)userById:(NSUInteger)userId
{
    for(User *user in self.users)
    {
        if(userId == user.userId)
        {
            return user;
        }
    }
    return nil;
}

#pragma mark - History button delegate

-(void)nameTapedWithTag:(NSUInteger)tag
{
    NSUInteger userId = [[self.issue.historyActions objectAtIndex:tag].userId integerValue];
    User *user = [self userById:userId];
    [self.datasorce requestImageWithName:user.avatar andImageType:ImageNameSimpleUserImage andHandler:^(UIImage *image, NSError *error) {
        if (image !=nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.profileImageBox updateImageForSubscribersWithImage:image];
            });
        }
    }];
    [self performSegueWithIdentifier:MySegueFromHistoryToProfile sender:user];
}


#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:MySegueFromHistoryToProfile])
    {
        ProfileViewController *profileController = (ProfileViewController*)segue.destinationViewController;
        profileController.isEditable = NO;
        profileController.user = (User*)sender;
        [self.profileImageBox.subscribersImageLoad addObject:profileController];
        profileController.profileImageBox = self.profileImageBox;
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
