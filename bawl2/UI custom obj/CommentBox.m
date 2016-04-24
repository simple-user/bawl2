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



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarWidthConstraint;


@end

@implementation CommentBox


#pragma mark - init

-(instancetype)init
{
    if(self = [super init])
        [self setUp];
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setUp];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
        [self setUp];
    return self;
}

-(void)setUp
{
    [self.avatarButton addTarget:self.buttonsDelegate action:@selector(avatarButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.nameButton addTarget:self.buttonsDelegate action:@selector(nameButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    self.translatesAutoresizingMaskIntoConstraints = NO;

}

-(void)fillWithName:(NSString*)name
         andMessage:(NSString*)message
andAvatarStringName:(NSString*)avatarStringName
     andAvatarImage:(UIImage*)avatarImage
andAvatarHeightWidth:(CGFloat)avatarHeightWidth
 andButtonsDelegate:(id)delegate
           andIndex:(NSUInteger)index
          andUserId:(NSNumber*)userID
{
    self.nameLabel.text = name;
    [self justifyMessage:message]; //self.messageLabel.text = message; --> setting with attributed string + sizetofit + numberLines
    self.avatarView.image = avatarImage;
    self.avatarHeightConstraint.constant = avatarHeightWidth;
    self.avatarWidthConstraint.constant = avatarHeightWidth;
    
    // temp init
    self.messageSmallHeight = self.messageHeightConstraint.constant;
    self.messageBigHeight = self.messageSmallHeight + 50;
    self.isBig = NO;
    self.isNeedResize = YES;
}

-(void)justifyMessage:(NSString*)message
{
    if ([self.messageLabel.text length] >0)
    {
        NSMutableParagraphStyle *paragraph= [[NSMutableParagraphStyle alloc] init];
        paragraph.alignment = NSTextAlignmentJustified;
        NSDictionary *attributes = @{NSFontAttributeName : self.messageLabel.font,
                                     NSParagraphStyleAttributeName : paragraph,
                                     NSBaselineOffsetAttributeName : @0};
        self.messageLabel.attributedText = [[NSAttributedString alloc] initWithString:message attributes:attributes];
        self.messageLabel.numberOfLines = 0;
        [self.messageLabel sizeToFit];
        
    }

}

-(void)updateInfoAbodutChandgingHeight
{
    
}


#pragma mark - Lasy instantiadtion + setters

-(void)setIndex:(NSUInteger)index
{
    self.avatarButton.tag = index;
    self.nameButton.tag = index;
    self.messageButton.tag = index;
}

-(void)setName:(NSString *)name
{
    self.nameLabel.text = name;
}

-(NSString*)name
{
    return self.nameLabel.text;
}

-(void)setMessage:(NSString *)message
{
    [self justifyMessage:message];
}

-(NSString*)message
{
    return self.messageLabel.attributedText.string;  // we are using only attributed string with message
}

-(void)setAvatarImage:(UIImage *)avatarImage
{
    self.avatarView.image = avatarImage;
}

-(UIImage*)avatarImage
{
    return self.avatarView.image;
}

-(void)setAvatarHeightWidth:(CGFloat)avatarHeightWidth
{
    self.avatarHeightConstraint.constant = avatarHeightWidth;
    self.avatarWidthConstraint.constant = avatarHeightWidth;
    [self layoutIfNeeded];
}

-(CGFloat)avatarHeightWidth
{
    return self.avatarHeightConstraint.constant;
}

#pragma mark - Actions


- (IBAction)messageTapped:(UIButton *)sender {
    if(self.isNeedResize==NO)
        return;
    else if (self.messageSmallHeight==0 || self.messageBigHeight==0)
        return;
    
    self.isBig = !self.isBig;
    if(self.isBig)
    {
        self.messageHeightConstraint.constant = self.messageBigHeight;
    }
    else
    {
        self.messageHeightConstraint.constant = self.messageSmallHeight;
    }
    [self updateConstraintsIfNeeded];
    
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

