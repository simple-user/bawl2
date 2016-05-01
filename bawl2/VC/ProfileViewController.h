//
//  ProfileViewController.h
//  net
//
//  Created by user on 2/10/16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "ProfileImageBox.h"

@interface ProfileViewController : UIViewController <ProfileImageBoxDelegate>


@property(nonatomic)BOOL isEditable;
@property(strong, nonatomic) User *user;
@property(strong, nonatomic) UIImage *userAvatar;
@property (strong, nonatomic) ProfileImageBox *profileImageBox;


@end
