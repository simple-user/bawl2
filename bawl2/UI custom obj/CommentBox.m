//
//  CommentBox.m
//  net
//
//  Created by Admin on 22.02.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "CommentBox.h"
#import "AvatarView.h"

@interface CommentBox()
@property (weak, nonatomic) IBOutlet AvatarView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
@property (weak, nonatomic) IBOutlet UIButton *nameButton;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomMessageConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomAvatarConstraint;


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
    
    self.layer.cornerRadius = 6;
}

-(void)fillWithName:(NSString*)name
         andMessage:(NSString*)message
andAvatarStringName:(NSString*)avatarStringName
andAvatarHeightWidth:(CGFloat)avatarHeightWidth
 andButtonsDelegate:(id)delegate
           andIndex:(NSUInteger)index
          andUser:(User*)user
{
    self.nameLabel.text = name;
    self.messageLabel.text = message;
    //[self justifyMessage:message]; //self.messageLabel.text = message; --> setting with attributed string + sizetofit + numberLines
    self.avatarStringName = avatarStringName;
    self.buttonsDelegate = delegate;
    self.index = index;
    self.user  =user;
    
    self.avatarHeightConstraint.constant = avatarHeightWidth;
    self.avatarWidthConstraint.constant = avatarHeightWidth;
    [self layoutIfNeeded];
    
    // sizes!
    
    CGFloat hSmall = self.messageHeightConstraint.constant;
    CGFloat hBig = [self getMessageBigHeight];
    self.messageBigHeight = hBig;

    if (hBig > hSmall)
    {
        // it needs transition, small size -> sets to default (auto layout in view)
        self.isNeedResize = YES;
        self.messageSmallHeight = self.messageHeightConstraint.constant;
    }
    else
    {
        // it doesn't need transition, and it's smaller then usual
        // so for good vertical aling text, we change size of message label
        // besides we need switch over bottom constraint
        CGFloat avatarBottom = self.avatarView.frame.origin.y + self.avatarView.bounds.size.height;
        CGFloat messageBottom = self.messageLabel.frame.origin.y + hBig;
        
        self.isNeedResize = NO;
        self.messageSmallHeight = hBig; // it doesn't have any matter
        self.messageHeightConstraint.constant = hBig;
        
        // by default we have active bottom message constraint
        if (messageBottom < avatarBottom)
        {
            // change constraint rules, if message bottom is upper than avatar botton :)
            self.bottomMessageConstraint.active = NO;
            self.bottomAvatarConstraint.active = YES;
        }
        [self layoutIfNeeded];
    }
    
    
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
        // [self.messageLabel sizeToFit];
        
    }

}

-(CGFloat)getMessageBigHeight
{
    CGFloat messageWidth = self.messageLabel.bounds.size.width;
    NSDictionary *attributes = [self.messageLabel.attributedText attributesAtIndex:0 effectiveRange:NULL];
    CGRect messageLabelRect =  [self.messageLabel.attributedText.string boundingRectWithSize:CGSizeMake(messageWidth, MAXFLOAT)
                                                                      options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingUsesDeviceMetrics)
                                                                                  attributes:attributes
                                                                      context:nil];
    CGRect messageLabelRect2 = CGRectIntegral(messageLabelRect);
    CGFloat messageLabelHeight = messageLabelRect2.size.height;
    
    return messageLabelHeight;
    
}


-(void)updateInfoAbodutChandgingHeight
{
    
}


#pragma mark - Lasy instantiadtion + setters

-(void)setIndex:(NSUInteger)index
{
    _index = index;
    self.avatarButton.tag = index;
    self.nameButton.tag = index;
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
    if(!self.isNeedResize==NO && !(self.messageSmallHeight==0 || self.messageBigHeight==0))
    {
        self.isBig = !self.isBig;
        if(self.isBig)
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.messageHeightConstraint.constant = self.messageBigHeight;
                [self layoutIfNeeded];
            }];

        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.messageHeightConstraint.constant = self.messageSmallHeight;
                [self layoutIfNeeded];
            }];
        }
        
        
    }
    
    // after change(or not) size - we call delegate message
    // so we can add some reaction on touch in controller
    [self.buttonsDelegate messageButtonTouchUpInside:self.index];
}




@end

