//
//  EditProfileViewController.m
//  bawl2
//
//  Created by Admin on 27.04.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "EditProfileViewController.h"
#import "Constants.h"
#import "UIColor+Bawl.h"
#import "CurrentItems.h"

@interface EditProfileViewController ()


@property (strong, nonatomic) IBOutlet UIImageView *avatarView;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UITextField *nameText;

@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UITextField *emailText;

@property(strong, nonatomic) User *user;
@end

@implementation EditProfileViewController



#pragma mark - Lasy Instantiation

-(void)setNameLabel:(UILabel *)nameLabel
{
    _nameLabel = nameLabel;
    _nameLabel.attributedText = [[NSAttributedString alloc] initWithString:@"NAME"
                                                                attributes:@{NSForegroundColorAttributeName : [UIColor bawlRedColor]}];
}

-(void)setEmailLabel:(UILabel *)emailLabel
{
    _emailLabel = emailLabel;
    _emailLabel.attributedText = [[NSAttributedString alloc] initWithString:@"EMAIL"
                                                                attributes:@{NSForegroundColorAttributeName : [UIColor bawlRedColor]}];
}

-(void)setNameText:(UITextField *)nameText
{
    _nameText = nameText;
    _nameText.text = self.user.name;
}

-(void)setEmailText:(UITextField *)emailText
{
    _emailText = emailText;
    _emailText.text = self.user.email;
}


-(User*)user
{
    if(!_user)
    {
        _user = [CurrentItems sharedItems].user;
    }
    return _user;
}



@end
