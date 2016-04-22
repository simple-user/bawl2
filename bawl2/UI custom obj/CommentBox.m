//
//  CommentBox.m
//  net
//
//  Created by Admin on 22.02.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "CommentBox.h"

@interface CommentBox()
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
@property (weak, nonatomic) IBOutlet UIButton *nameButton;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;


@end

@implementation CommentBox


#pragma mark - Lasy instantiadtion + setters

-(void)setIndex:(NSUInteger)index
{
    self.avatarButton.tag = index;
    self.nameButton.tag = index;
    self.messageButton.tag = index;
}


#pragma mark - Actions
- (IBAction)avatarButtonClicked:(UIButton *)sender
{
}


- (IBAction)snameButtonClicked:(UIButton *)sender
{
}

- (IBAction)messageButtonClicked:(UIButton *)sender
{
}


//-(instancetype)initWithView:(UIView*)view
//                andUserName:(UILabel*)name
//              andButtonName:(UIButton*)buttonName
//             andUserMessage:(UILabel*)message
//           andButtonMessage:(UIButton*)buttonMessage
//                  andAvatar:(AvatarView*) avatar
//            andButtonAvatar:(UIButton*) buttonAvatar;
//{
//    if(self = [super init])
//    {
//        _avatar = avatar;
//        _buttonImage = buttonAvatar;
//        _commentLabelMessage = message;
//        _buttonMessage = buttonMessage;
//        _commentLabelName = name;
//        _buttonName = buttonName;
//        _commentView = view;
//    }
//    return self;
//}
//
//-(void)removeElementsFromSuperView
//{
//    [self.avatar removeFromSuperview];
//    [self.buttonImage removeFromSuperview];
//    [self.commentLabelName removeFromSuperview];
//    [self.buttonName removeFromSuperview];
//    [self.commentLabelMessage removeFromSuperview];
//    [self.buttonMessage removeFromSuperview];
//    [self.commentView removeFromSuperview];
//}
//
//-(void)takeElementsToTop
//{
//    UIView *superView = self.avatar.superview;
//    [superView bringSubviewToFront:self.avatar];
//    [superView bringSubviewToFront:self.buttonImage];
//    [superView bringSubviewToFront:self.commentLabelName];
//    [superView bringSubviewToFront:self.buttonName];
//    [superView bringSubviewToFront:self.commentLabelMessage];
//    [superView bringSubviewToFront:self.buttonMessage];
//}
//
//

@end

