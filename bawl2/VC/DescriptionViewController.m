//
//  DescriptionViewController.m
//  net
//
//  Created by Admin on 19/01/16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "UIColor+Bawl.h"
#import "DescriptionViewController.h"
#import "HistoryViewController.h"
#import "IssueChangeStatus.h"
#import "NetworkDataSorce.h"
#import "ChangerBox.h"
#import "CurrentItems.h"
#import "IssueCategories.h"
#import "AvatarView.h"
#import "Comment.h"
#import "CommentBox.h"
#import "ProfileViewController.h"
#import "MyAlert.h"
#import "Constants.h"
#import "ProfileImageBox.h"


@interface DescriptionViewController () <IssueImageDelegate, CommentBoxButtonsDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *categoryImageView;

@property (weak, nonatomic) IBOutlet UILabel *currentStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *changeStatusArrow;
@property (strong, nonatomic) IBOutlet UIButton *changeButton;

@property (weak, nonatomic) IBOutlet UIImageView *issueImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UILabel *commentLabelOnButton;
@property (weak, nonatomic) IBOutlet UIView *viewBetweenCommentAndShare;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *coverScrollView;

@property (strong, nonatomic) IssueChangeStatus *statusChanger;
@property (strong, nonatomic) id <DataSorceProtocol> dataSorce;
@property (strong, nonatomic) NSArray <NSString*> *stringNewStatuses;

@property (strong, nonatomic) UIView *viewToConnectDynamicItems;

@property (strong, nonatomic) UIView *backGreyView;
@property (strong, nonatomic) NSMutableArray <CommentBox*> *commentBoxArr;

@property (strong,nonatomic) NSMutableDictionary <NSString*, UIImage*> *avatarNamesAndImagesDic;
@property (strong, nonatomic) ProfileImageBox *profileImageBox;

@property(nonatomic) CGFloat avatarSize;
@property(nonatomic) CGFloat contentStaticHeight;
@property(nonatomic) CGFloat contentDynamicHeight;

// @property(strong, nonatomic)NSNumber *callingSegueToProfileUserId;

@end

@implementation DescriptionViewController



#pragma mark - Lasy instantiation


-(ProfileImageBox*)profileImageBox
{
    if(_profileImageBox == nil)
    {
        _profileImageBox = [[ProfileImageBox alloc] init];
    }
    return _profileImageBox;
}


-(NSMutableDictionary <NSString*, UIImage*> *)avatarNamesAndImagesDic
{
    if(_avatarNamesAndImagesDic==nil)
        _avatarNamesAndImagesDic = [[NSMutableDictionary alloc] init];
    return _avatarNamesAndImagesDic;
}

-(NSMutableArray <CommentBox*> *)commentBoxArr
{
    if(_commentBoxArr==nil)
        _commentBoxArr = [[NSMutableArray alloc] init];
    return _commentBoxArr;
}


-(IssueChangeStatus*)statusChanger
{
    if(_statusChanger == nil)
        _statusChanger = [[IssueChangeStatus alloc] init];
    return _statusChanger;
}

-(id<DataSorceProtocol>)dataSorce
{
    if(_dataSorce == nil)
        _dataSorce = [[NetworkDataSorce alloc] init];
    return _dataSorce;
}

#pragma mark - View appear / disappear (+ loading data)

-(void)viewDidLoad
{
    CurrentItems *cItems = [CurrentItems sharedItems];
    [cItems.issueImageDelegates addObject:self];
    self.avatarSize = self.contentView.frame.size.width / 10;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(tapOnCoverScrollView)];
    
    [self.coverScrollView addGestureRecognizer:tap];
    // it have to update avatars even if user passed to edit view
    // and this observer will be removed only if view dealocates
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateAvatarImages:)
                                                 name:@"updateAvatarImages" object:nil];
}


-(void)tapOnCoverScrollView
{

}

- (void) viewWillAppear:(BOOL)animated
{
    [self addObservers];
    [self setDataToView];
    // [self drawTwoComments];
    
}

-(void)setDataToView
{
    CurrentItems *ci = [CurrentItems sharedItems];
    self.titleLabel.text = ci.issue.name;
    self.titleLabel.textColor = [UIColor bawlRedColor];
    self.descriptionLabel.text = ci.issue.issueDescription;
    self.currentStatusLabel.text = ci.issue.status;
    self.categoryImageView.image = [[IssueCategories standartCategories] imageForCurrentCategory];
    
    if(ci.issueImage==nil)
    {
        // so image is still downloading
        self.issueImageView.image = nil;
    }
    else if( ![self.issueImageView.image isEqual:ci.issueImage])
    {
        self.issueImageView.image = ci.issueImage;
    }
    
}

-(void)addObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)    name:UIDeviceOrientationDidChangeNotification  object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
   

}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [self clearOldDynamicElements];
}


-(void)viewDidAppear:(BOOL)animated
{
    [self calculateContentViewStaticHeight];
    [self requestUsersAndComments];
}

-(void)orientationChanged:(NSNotification*)notification
{
    [self calculateContentViewStaticHeight];
    self.contentViewHeightConstraint.constant  = self.contentStaticHeight + self.contentDynamicHeight;
}

-(void)calculateContentViewStaticHeight
{
    self.contentStaticHeight = self.viewBetweenCommentAndShare.frame.origin.y + self.viewBetweenCommentAndShare.frame.size.height;
}

// when avatar image is loaded, it sends notificstion to update all images with this string file name
#pragma mark update Avatars with notification
-(void)updateAvatarImages:(NSNotification*)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSString *dictionaryKey = userInfo.allKeys.firstObject;
    UIImage *dictionaryVal = userInfo.allValues.firstObject;
    for (CommentBox *box in self.commentBoxArr)
    {
        if ([box.avatarStringName isEqualToString:dictionaryKey])
        {
            box.avatarImage = dictionaryVal;
        }
        
        if([self.profileImageBox.name isEqualToString:dictionaryKey])
        {
            [self.profileImageBox updateImageForSubscribersWithImage:dictionaryVal];
        }
        
    }
}



// test method
-(void)drawTwoComments
{
    NSArray *nibContext = [[NSBundle mainBundle] loadNibNamed:@"commentView" owner:nil options:nil];
    CommentBox *cb = [nibContext firstObject];
    [cb fillWithName:@"first Name"
          andMessage:@"First smessage"
 andAvatarStringName:nil
andAvatarHeightWidth:self.avatarSize
  andButtonsDelegate:nil
            andIndex:1
             andUser:nil];
    
    [self.contentView addSubview:cb];
    [cb.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor].active=YES;
    [cb.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor].active=YES;
    [cb.topAnchor constraintEqualToAnchor:self.viewBetweenCommentAndShare.bottomAnchor].active=YES;
    self.viewToConnectDynamicItems = cb;
    
    nibContext = [[NSBundle mainBundle] loadNibNamed:@"commentView" owner:nil options:nil];
    cb = [nibContext firstObject];
    [cb fillWithName:@"second Name"
          andMessage:@"second smessage"
 andAvatarStringName:nil
andAvatarHeightWidth:self.avatarSize
  andButtonsDelegate:nil
            andIndex:2
             andUser:nil];
    
    [self.contentView addSubview:cb];
    [cb.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor].active=YES;
    [cb.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor].active=YES;
    [cb.topAnchor constraintEqualToAnchor:self.viewToConnectDynamicItems.bottomAnchor].active=YES;
}


#pragma mark - IssueImageDelegate
-(void)updateIssueImage
{
    CurrentItems *cItems = [CurrentItems sharedItems];
    if (![self.issueImageView.image isEqual:cItems.issueImage])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.issueImageView.image = [CurrentItems sharedItems].issueImage;
        });
        
    }
}

-(void)issueImageDidLoad
{
    [self updateIssueImage];
}

-(void)issueImageDidFailedLoad
{
    [self updateIssueImage];
}


#pragma mark - actions

- (IBAction)changeStatus:(UIButton *)sender
{
    [self showNewStatuses];
}

- (IBAction)addNewComment:(UIButton *)sender
{

}

-(NSLayoutConstraint*)scrollBottomConstraint
{
    for(NSLayoutConstraint *constraint in self.view.constraints)
    {
        if ([constraint.identifier isEqualToString:@"BottomScrollViewConstraint"])
        {
            return constraint;
            
        }
    }
    return nil;
    
}

-(void)keyboardDidShow:(NSNotification *)notification
{

    
    
    
}

-(void)keyboardWillHide
{
  
}

-(void)sendCommentPressed
{

}

-(void)requestUsersAndAddNewCommentsAndSendMessage:(NSString*)message
{
    __weak DescriptionViewController *weakSelf = self;
    [self.dataSorce requestAllUsers:^(NSArray<User *> *users, NSError *error) {
        [weakSelf sendMessage:message andAddnewCommentsBlockWithAllUsers:users];
    }];
}

-(void)sendMessage:(NSString*)message andAddnewCommentsBlockWithAllUsers:(NSArray <User *> *)users
{
    __weak DescriptionViewController *weakSelf = self;
    
    [self.dataSorce requestSendNewComment:message
    forIssueID:[CurrentItems sharedItems].issue.issueId
    andHandler:^(NSArray<NSDictionary<NSString *,id> *> *commentDics, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(commentDics==nil || error != nil)
                return;
           
            for (NSInteger index=self.commentBoxArr.count; index<commentDics.count; ++index)
            {
               
               NSDictionary<NSString *,id> *commentDic = commentDics[index];
               User *user = [self userFromAllUsers:users withUserID:[commentDic objectForKey:@"USER_ID"]];
               [weakSelf addOneComment:commentDic withIndex:index user:user];
            }
           
            CGFloat newContentViewHeight = weakSelf.contentDynamicHeight + weakSelf.contentStaticHeight;
            CGFloat scrollViewHeight = weakSelf.scrollView.frame.size.height;
            if(newContentViewHeight < scrollViewHeight)
                weakSelf.contentViewHeightConstraint.constant = scrollViewHeight;
            else
                weakSelf.contentViewHeightConstraint.constant = newContentViewHeight;

            [weakSelf.view layoutIfNeeded];
            
            CGFloat yOffset = self.contentView.frame.size.height - self.scrollView.frame.size.height;
            if (yOffset>0)
            {
                [UIView animateWithDuration:0.3 animations:^{
                    self.scrollView.contentOffset = CGPointMake(0, yOffset);
                }];
            }
        });
    }];
    
}



#pragma mark - Dynamic elements

-(void)requestUsersAndComments
{
    __weak DescriptionViewController *weakSelf = self;
    [self.dataSorce requestAllUsers:^(NSArray<User *> *users, NSError *error) {
        [weakSelf commentBlockWithAllUsers:users];
    }];
}



-(void)commentBlockWithAllUsers:(NSArray<User*> *) users
{
    __weak DescriptionViewController *weakSelf = self;
    self.viewToConnectDynamicItems = self.viewBetweenCommentAndShare;
    
    [self.dataSorce requestCommentsWithIssueID:[CurrentItems sharedItems].issue.issueId
                                    andHandler:^(NSArray<NSDictionary<NSString *,id> *> *commentDics, NSError *error) {
       dispatch_async(dispatch_get_main_queue(), ^{
           weakSelf.contentViewHeightConstraint.constant =  weakSelf.contentStaticHeight;
           [weakSelf.view layoutIfNeeded];
           weakSelf.contentDynamicHeight = 0;
           if(commentDics==nil || error != nil || [commentDics isKindOfClass: [NSDictionary class]])
               return;
           for (NSInteger index=0; index<commentDics.count; ++index)
           {
               
               NSDictionary<NSString *,id> *commentDic = commentDics[index];
               User *user = [self userFromAllUsers:users withUserID:[commentDic objectForKey:@"USER_ID"]];
               [weakSelf addOneComment:commentDic withIndex:index user:user];
           }

           CGFloat newContentViewHeight = weakSelf.contentDynamicHeight + weakSelf.contentStaticHeight;
           CGFloat scrollViewHeight = weakSelf.scrollView.frame.size.height;
           if(newContentViewHeight < scrollViewHeight)
               weakSelf.contentViewHeightConstraint.constant = scrollViewHeight;
           else
               weakSelf.contentViewHeightConstraint.constant = newContentViewHeight;
           
           [weakSelf.view layoutIfNeeded];
//           NSLog(@"Content static height: %f", weakSelf.contentStaticHeight);
//           NSLog(@"Content dynamic height: %f", weakSelf.contentDynamicHeight);
//           NSLog(@"Content height: %f", newContentViewHeight);
//           NSLog(@"Scroll height: %f", scrollViewHeight);
       });
    }];
    
}

-(User *)userFromAllUsers:(NSArray<User *> *)users withUserID:(NSNumber*)userId
{
    User *user = nil;
    for (User *u in users)
    {
        if(u.userId == userId.integerValue)
        {
            user = u;
            break;
        }
    }
    return user;
}



-(void)addOneComment:(NSDictionary <NSString*, id> *)commentDic withIndex:(NSInteger)index user:(User *) user
{
    NSArray *nibContext = [[NSBundle mainBundle] loadNibNamed:@"commentView" owner:nil options:nil];
    CommentBox *cb = [nibContext firstObject];
    Comment *comment = [[Comment alloc] initWithCommentDictionary:commentDic andUser:user andUIImage:cb.avatarImage andImageDictionary:self.avatarNamesAndImagesDic];
    
    cb.alpha=0.0;
    [self.contentView addSubview:cb];
    [cb.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor].active=YES;
    [cb.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor].active=YES;
    [cb.topAnchor constraintEqualToAnchor:self.viewToConnectDynamicItems.bottomAnchor].active=YES;
    self.viewToConnectDynamicItems = cb;
    [self.commentBoxArr addObject:cb];
    self.contentDynamicHeight += cb.frame.size.height;
    self.contentViewHeightConstraint.constant += cb.frame.size.height;
    [self.view layoutIfNeeded];
    
    cb.layer.borderWidth = 1.0;
    cb.layer.borderColor = [[UIColor blackColor] CGColor];
    
    // we need correct value of self.bounds.size.width
    // so we call fill method after adding layout stuff
    
    [cb fillWithName:comment.userName
          andMessage:comment.userMessage
 andAvatarStringName:user.avatar
andAvatarHeightWidth:self.avatarSize
  andButtonsDelegate:self
            andIndex:index
             andUser:user];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        cb.alpha = 1.0;
    }];
}


#pragma mark - Comment Box Buttons delegate

-(void)nameButtonTouchUpInside:(UIButton *)sender
{
    [self callSegueToProfileWitTappedButton:sender];
}

-(void)avatarButtonTouchUpInside:(UIButton *)sender
{
    [self callSegueToProfileWitTappedButton:sender];
}

-(void)messageButtonTouchUpInside:(NSInteger)index
{
    CommentBox *box = self.commentBoxArr[index];
    CGFloat changeHeight = box.messageBigHeight - box.messageSmallHeight;
    CGFloat newContentHeight = self.contentViewHeightConstraint.constant + changeHeight;

    [UIView animateWithDuration:0.3 animations:^{
        self.contentViewHeightConstraint.constant = newContentHeight;
        [self.contentView layoutIfNeeded];
    }];
}

-(void)callSegueToProfileWitTappedButton:(UIButton*) sender
{
    NSInteger index = sender.tag;
    CommentBox *box = self.commentBoxArr[index];
    // self.callingSegueToProfileUserId = box.userID;
    [self performSegueWithIdentifier:MySegueFromDescriptionToProfile sender:box];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:MySegueFromDescriptionToProfile]) {
        if([segue.destinationViewController isKindOfClass:[ProfileViewController class]])
        {
            ProfileViewController *profileViewController = (ProfileViewController*)segue.destinationViewController;
            CommentBox *cBox = (CommentBox*)sender;
            profileViewController.isEditable = NO;
            profileViewController.user = cBox.user;
            if(cBox.avatarImage != nil)
            {
                profileViewController.userAvatar = cBox.avatarImage;
                self.profileImageBox = nil;
            }
            else
            {
                self.profileImageBox.name = cBox.avatarStringName;
                [self.profileImageBox.subscribersImageLoad addObject:profileViewController];
                profileViewController.profileImageBox = self.profileImageBox;
            }
        }
    }
}




-(void)clearOldDynamicElements
{

}

-(void)prepareUIChangeStatusElements
{
    User *currentUser = [CurrentItems sharedItems].user;
    if (currentUser==nil)
        self.stringNewStatuses = nil;
    else
        self.stringNewStatuses = [self.statusChanger newIssueStatusesForUser:currentUser.stringRole andCurretIssueStatus:[CurrentItems sharedItems].issue.status];
    
    // just for testing
    // self.stringNewStatuses = @[@"111", @"222", @"333"];
    
    if (self.stringNewStatuses == nil)
    {
        self.changeStatusArrow.hidden = YES;
        self.changeButton.hidden = YES;
    }
    else
    {
        self.changeStatusArrow.hidden = NO;
        self.changeButton.hidden = NO;
    }
}



-(void)showNewStatuses
{
}



-(void)rerformChangeStatus:(UIButton*)sender
{
}
    
                             
                             
    
                         

@end
