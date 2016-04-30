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

@interface ProfileViewController () <UserImageDelegate, ProfileImageBoxDelegate>

@property (weak, nonatomic) IBOutlet AvatarView *avatarView;

@property (weak, nonatomic) IBOutlet UILabel *fullName;

@property (weak, nonatomic) IBOutlet UITextField *login;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *role;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;

@property(strong, nonatomic) User *userUnchangedCopy;
@property(strong, nonatomic) UIImage *userAvatarUnchangedCopy;
@end

@implementation ProfileViewController


#pragma - Lasy Instantiation


-(ProfileImageBox*)profileImageBox
{
    if(_profileImageBox == nil)
    {
        _profileImageBox = [[ProfileImageBox alloc] init];
        _profileImageBox.delegate = self;
    }
    return _profileImageBox;
}

// every time, when view appears
-(void)updateUserIfNeeded
{
    if (![self.user isEqual:self.userUnchangedCopy])
    {
        self.userUnchangedCopy = self.user;
        self.fullName.attributedText = [[NSAttributedString alloc] initWithString:self.user.name
                                                                       attributes:@{NSForegroundColorAttributeName : [UIColor bawlRedColor]}];
        self.login.text = self.user.login;
        self.email.text = self.user.email;
        self.role.text = [self.user.stringRole lowercaseString];

    }
}

-(void)updateUserAvatarIfNeeded
{
    if(![self.userAvatar isEqual:self.userAvatarUnchangedCopy])
    {
        self.userAvatarUnchangedCopy = self.userAvatar;
        self.avatarView.image = self.userAvatar;
    }
}

// once on load
-(void)setEditButton:(UIBarButtonItem *)editButton
{
    _editButton = editButton;
    _editButton.enabled = self.isEditable;
    
        
}


#pragma mark - Init / appear ...

-(void)viewDidLoad
{
    CurrentItems *ci = [CurrentItems sharedItems];
    [ci.userImageDelegates addObject:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self updateUserIfNeeded];
    [self updateUserAvatarIfNeeded];
}


#pragma mark - User image delegate

-(void)userImageDidLoad
{
    self.userAvatar = [CurrentItems sharedItems].userImage;
    [self updateUserAvatarIfNeeded];
}

-(void)userImageDidFailedLoad
{
    self.userAvatar = [CurrentItems sharedItems].userImage;
    [self updateUserAvatarIfNeeded];
}

#pragma mark - Profile image box delegate
-(void)profileImageBoxUpdatedImage:(UIImage *)image
{
    self.avatarView.image = image;
}

@end















