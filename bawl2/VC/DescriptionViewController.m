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
#import "NewCommentView.h"


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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewBottomConstraint;

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

@property(nonatomic) BOOL isCommentLoaded; // we load comments in viewDidAppear (becouse we need right values of frames)
// but wdhen user press back on phofile or history - coments don't start loading once more
// in future we can change mechanism to load coments at first time, and just update them at other

// @property(strong, nonatomic)NSNumber *callingSegueToProfileUserId;

// properties for backup original bar button items (before adding comment buttons change them)
// they will be nil, until user taps adding new comment button
@property(strong, nonatomic) NSArray *rightBarButtonItems;
@property(strong, nonatomic) NSArray *leftBarButtonItems;
@property(weak, nonatomic) NewCommentView *addingCommentView;
@property(strong, nonatomic) NSString *addingCommentText;

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
    [self prepareUIChangeStatusButton];
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
}


-(void)viewDidAppear:(BOOL)animated
{
    if(self.isCommentLoaded == NO)
    {
        [self calculateContentViewStaticHeight];
        // this is the first load of comments, so we're doing it from 0 index
        [self requestUsersAndAddCommentsFromIndex:0];
        self.isCommentLoaded = YES;
    }
    
}

-(void)prepareUIChangeStatusButton
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

#pragma mark - Orientation change notification

-(void)orientationChanged:(NSNotification*)notification
{
    [self calculateContentViewStaticHeight];
    self.contentViewHeightConstraint.constant  = self.contentStaticHeight + self.contentDynamicHeight;
}

-(void)calculateContentViewStaticHeight
{
    CGFloat staticHeight = self.viewBetweenCommentAndShare.frame.origin.y + self.viewBetweenCommentAndShare.frame.size.height;
    self.contentStaticHeight = staticHeight;
    self.contentViewHeightConstraint.constant =  staticHeight;
    [self.view layoutIfNeeded];
    self.contentDynamicHeight = 0;
    self.viewToConnectDynamicItems = self.viewBetweenCommentAndShare;

}

// when avatar image is loaded, it sends notification to update all images with this string file name
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

#pragma mark - IssueImageDelegate
-(void)issueImageDidLoad
{
    [self updateIssueImage];
}

-(void)issueImageDidFailedLoad
{
    [self updateIssueImage];
}

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


#pragma mark - actions

- (IBAction)changeStatus:(UIButton *)sender
{
    UIAlertController *changerController = [UIAlertController alertControllerWithTitle:@"Changing issue status"
                                                                               message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *changerAction = nil;
    
    for (NSString *newStatus in self.stringNewStatuses)
    {
        NSString *newStatusReadable = [self.statusChanger labelTextForNewStatus:newStatus];
        changerAction = [UIAlertAction actionWithTitle:newStatusReadable style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * _Nonnull action) {
                                   [self newStatusPressedWithTitle:action.title];
                               }];
        [changerController addAction: changerAction];
    }
    
    changerAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [changerController addAction:changerAction];
    [self presentViewController:changerController animated:YES completion:nil];
}

-(void)newStatusPressedWithTitle:(NSString*)title
{
    NSString *originalNewStatus = [self.statusChanger originalNewStatusForLaxbelText:title];
    NSNumber *issueId = [CurrentItems sharedItems].issue.issueId;
    [self.dataSorce requestChangeStatusWithID:issueId toStatus:originalNewStatus
     andViewControllerHandler:^(NSString *stringAnswer, Issue *issue, NSError *error) {
         if(stringAnswer==nil)
         {
             CurrentItems *ci = [CurrentItems sharedItems];
             ci.issue = issue;
             dispatch_async(dispatch_get_main_queue(), ^{
                self.currentStatusLabel.text = issue.status;
                [self prepareUIChangeStatusButton];
             });
         }
     }];
}



#pragma mark - Keyboard notifications
-(void)keyboardDidShow:(NSNotification *)notification
{
    NSDictionary *dic = notification.userInfo;
    NSValue *keyboardFrame = dic[UIKeyboardFrameEndUserInfoKey];
    CGRect frame = [keyboardFrame CGRectValue];
    CGRect viewFrame = [self.view convertRect:frame fromView:nil];
    CGFloat keyboardHeight = viewFrame.size.height;
    
    self.scrollViewBottomConstraint.constant = keyboardHeight;
    [self.view layoutIfNeeded];

    
    
    
}

-(void)keyboardWillHide
{
    self.scrollViewBottomConstraint.constant = 0;
    [self.view layoutIfNeeded];
  
}


#pragma mark - Comments

-(void)requestUsersAndAddCommentsFromIndex:(NSUInteger)index
{
    __weak DescriptionViewController *weakSelf = self;
    [self.dataSorce requestAllUsers:^(NSArray<User *> *users, NSError *error) {
        [weakSelf commentBlockWithAllUsers:users fromIndex:index];
    }];
}

-(void)commentBlockWithAllUsers:(NSArray<User*> *) users fromIndex:(NSUInteger)startIndex
{
    __weak DescriptionViewController *weakSelf = self;
    [self.dataSorce requestCommentsWithIssueID:[CurrentItems sharedItems].issue.issueId
                                    andHandler:^(NSArray<NSDictionary<NSString *,id> *> *commentDics, NSError *error) {
       dispatch_async(dispatch_get_main_queue(), ^{
           if(commentDics==nil || error != nil || [commentDics isKindOfClass: [NSDictionary class]])
               return;
           for (NSInteger index=startIndex; index<commentDics.count; ++index)
           {
               
               NSDictionary<NSString *,id> *commentDic = commentDics[index];
               User *user = [self userFromAllUsers:users withUserID:[commentDic objectForKey:@"USER_ID"]];
               [weakSelf addOneComment:commentDic withIndex:index user:user];
           }

           CGFloat newContentViewHeight = weakSelf.contentDynamicHeight + weakSelf.contentStaticHeight;
           CGFloat scrollViewHeight = weakSelf.scrollView.frame.size.height;
//           if(newContentViewHeight < scrollViewHeight)
//               weakSelf.contentViewHeightConstraint.constant = scrollViewHeight;
//           else
               weakSelf.contentViewHeightConstraint.constant = newContentViewHeight;
           
           [weakSelf.view layoutIfNeeded];
           
           // if we add new coment (index!=0) we have to scroll down, to show this comment
           if(startIndex!=0)
           {
               CGFloat yOffset = newContentViewHeight - scrollViewHeight;
               if (yOffset > 0)
               {
                   [UIView animateWithDuration:0.4 animations:^{
                       self.scrollView.contentOffset = CGPointMake(0, yOffset);
                   }];
               }
           }
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


#define COMMENT_UPPER_OFFSET_FROM_PREVIOUS_ELEMENT 2

-(void)addOneComment:(NSDictionary <NSString*, id> *)commentDic withIndex:(NSInteger)index user:(User *) user
{
    NSArray *nibContext = [[NSBundle mainBundle] loadNibNamed:CustomViewCommentView owner:nil options:nil];
    CommentBox *cb = [nibContext firstObject];
    Comment *comment = [[Comment alloc] initWithCommentDictionary:commentDic andUser:user andComentBox:cb andImageDictionary:self.avatarNamesAndImagesDic];
    
    cb.alpha=0.0;
    [self.contentView addSubview:cb];
    [cb.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:3].active=YES;
    [cb.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-3].active=YES;
    [cb.topAnchor constraintEqualToAnchor:self.viewToConnectDynamicItems.bottomAnchor constant:COMMENT_UPPER_OFFSET_FROM_PREVIOUS_ELEMENT].active=YES;
    self.viewToConnectDynamicItems = cb;
    [self.commentBoxArr addObject:cb];

    // we need correct value of self.bounds.size.width
    // so we call fill method after adding layout stuff
    
    [cb fillWithName:comment.userName
          andMessage:comment.userMessage
 andAvatarStringName:user.avatar
andAvatarHeightWidth:self.avatarSize
  andButtonsDelegate:self
            andIndex:index
             andUser:user];
    
    // height of comment could ;change in fillWithName... method (with updating layout). So we update the value of content height after it.
    self.contentDynamicHeight += cb.frame.size.height + COMMENT_UPPER_OFFSET_FROM_PREVIOUS_ELEMENT;
    self.contentViewHeightConstraint.constant += cb.frame.size.height;

    [UIView animateWithDuration:0.3 animations:^{
        cb.alpha = 1.0;
    }];
    
}


#pragma mark - Adding new comment

- (IBAction)addNewCommentPressed
{
    // first - backup left and right bar items
    self.leftBarButtonItems = self.navigationItem.leftBarButtonItems;
    self.rightBarButtonItems = self.navigationItem.rightBarButtonItems;
    
    UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithTitle:@"cancel" style:UIBarButtonItemStylePlain target:self action:@selector(newCommentCancelPressed)];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithTitle:@"post" style:UIBarButtonItemStyleDone target:self action:@selector(newCommentDonePressed)];
    self.navigationItem.leftBarButtonItems = @[cancelBarButton];
    self.navigationItem.rightBarButtonItems = @[doneBarButton];
    
    NSArray *nibContext = [[NSBundle mainBundle] loadNibNamed:CustomViewNewCommentView owner:nil options:nil];
    NewCommentView *newComment = [nibContext firstObject];
    self.addingCommentView = newComment;
    newComment.translatesAutoresizingMaskIntoConstraints = NO;
    // this view will uppear at the top of all views
    [self.view addSubview:newComment];
    
    
    //layout
    //if we constraint bottom of this view to bottom of scroll, then it will move with changing height of scroll
    // when keyboard appears, or it will be in the bottom of view, if keyboard doesn't appear
    [newComment.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor].active = YES;
    [newComment.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor].active = YES;
    [newComment.bottomAnchor constraintEqualToAnchor:self.scrollView.bottomAnchor].active = YES;
    [self.view layoutIfNeeded];
    
    [newComment.textView becomeFirstResponder];

    
    
}

-(void)newCommentDonePressed
{
    NSString *trimmedString = [self.addingCommentView.textView.text stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    
    if([trimmedString length] == 0)
    {
        [self newCommentCancelPressed];
        return;
    }

    self.addingCommentText = trimmedString;
    
    // post
    NSNumber *issueId = [CurrentItems sharedItems].issue.issueId;
    [self.dataSorce requestSendNewComment:trimmedString forIssueID:issueId
    andHandler:^(NSArray<NSDictionary<NSString *,id> *> *commentDics, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (commentDics != nil && [commentDics isKindOfClass:[NSArray class]]  && error == nil)
            {
                    // we don't update existing comment, just add new (there can be other besides our)
                    NSUInteger startIndexAddingComments = [self.commentBoxArr count];
                    [self requestUsersAndAddCommentsFromIndex:startIndexAddingComments];
            }
            [self newCommentCancelPressed];
        });

        
    }];
    
}

-(void)newCommentCancelPressed
{
    [self.addingCommentView.textView resignFirstResponder];
    [self.addingCommentView removeFromSuperview];
    self.navigationItem.leftBarButtonItems = self.leftBarButtonItems;
    self.navigationItem.rightBarButtonItems = self.rightBarButtonItems;
    self.leftBarButtonItems = nil;
    self.rightBarButtonItems = nil;
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

-(void)callSegueToProfileWitTappedButton:(UIButton*) sender
{
    NSInteger index = sender.tag;
    CommentBox *box = self.commentBoxArr[index];
    // self.callingSegueToProfileUserId = box.userID;
    [self performSegueWithIdentifier:MySegueFromDescriptionToProfile sender:box];
}

-(void)messageButtonTouchUpInside:(NSInteger)index
{
    CommentBox *box = self.commentBoxArr[index];
    CGFloat changeHeight = box.messageBigHeight - box.messageSmallHeight;
    if(box.isBig == NO)
        changeHeight *= -1;
    self.contentDynamicHeight+= changeHeight;
    CGFloat newContentHeight = self.contentViewHeightConstraint.constant + changeHeight;

    [UIView animateWithDuration:0.3 animations:^{
        self.contentViewHeightConstraint.constant = newContentHeight;
        [self.contentView layoutIfNeeded];
    }];
}



#pragma mark - Segue
- (IBAction)backButton:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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


@end
