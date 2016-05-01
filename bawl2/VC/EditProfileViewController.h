//
//  EditProfileViewController.h
//  bawl2
//
//  Created by Admin on 27.04.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "ProfileImageBox.h"

@interface EditProfileViewController : UIViewController <ProfileImageBoxDelegate>

// if user went from map thrue profile to edit, edit can appear before avatar is loaded.
// so we need to pass profile image box
@property(strong,nonatomic) ProfileImageBox *profileImageBox;

@end
