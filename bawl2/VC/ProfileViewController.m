//
//  ProfileViewController.m
//  bawl2
//
//  Created by user on ---
//  Copyright © 2016 Admin. All rights reserved.
//


#import "ProfileViewController.h"
#import "AvatarView.h"
#import "UIColor+Bawl.h"
#import "CurrentItems.h"
#import "Constants.h"
#import "EditProfileViewController.h"

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet AvatarView *avatarView;

@property (weak, nonatomic) IBOutlet UILabel *fullName;

@property (weak, nonatomic) IBOutlet UITextField *login;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *role;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;
@end

@implementation ProfileViewController


#pragma - Lasy Instantiation

-(User*)getUser
{
    if(self.isEditable == YES)
        return [CurrentItems sharedItems].user;
    else
        return self.user;
}


-(void)setEditButton:(UIBarButtonItem *)editButton
{
    _editButton = editButton;
    if(!self.isEditable)
        _editButton.enabled = NO;
}

-(void)setAvatarView:(AvatarView *)avatarView
{
    _avatarView = avatarView;
    if(self.isEditable == YES)
    {
        CurrentItems *ci = [CurrentItems sharedItems];
        _avatarView.image = ci.userImage;
    }
    else
    {
        _avatarView.image = self.userAvatar;
    }
    
}

-(void)setFullName:(UILabel *)fullName
{
    _fullName = fullName;
    NSString *userFullName = [self getUser].name;
    _fullName.attributedText = [[NSAttributedString alloc] initWithString:userFullName
                                                               attributes:@{NSForegroundColorAttributeName : [UIColor bawlRedColor]}];
}

-(void)setLogin:(UITextField *)login
{
    _login = login;
    _login.text = [self getUser].login;
}

-(void)setEmail:(UITextField *)email
{
    _email = email;
    _email.text = [self getUser].email;
}

-(void)setRole:(UITextField *)role
{
    _role = role;
    _role.text = [[self getUser].stringRole lowercaseString];
}


#pragma mark - Init / appear ...


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(self.isEditable==YES)
    {
        CurrentItems *ci = [CurrentItems sharedItems];
        if (ci.userImage!=nil)
        {
            self.avatarView.image = ci.userImage;
        }
        else
        {
            // downloading in process -> can be only with segwey from map (profile button)
            // self.avatarView.image is already nil
            // so we just waiting for notification
        }
    }
    else
    {
        // commentator from description
        self.avatarView.image = self.userAvatar;
        // if it's nil - than it will be clear, and wait for notification
    }
}


-(void)addNotificstionObservers
{
    [[NSNotificationCenter defaultCenter] addObserverForName:MyNotificationUserAvatarDownloadSuccess
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      if(self.isEditable==YES)
                                                      {
                                                          self.avatarView.image = [CurrentItems sharedItems].userImage;
                                                      }
                                                  }];
    [[NSNotificationCenter defaultCenter] addObserverForName:MyNotificationUserAvatarDownloadFailed
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      if(self.isEditable==YES)
                                                      {
                                                          self.avatarView.image = [CurrentItems sharedItems].userImage;
                                                      }
                                                  }];

}


-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end















