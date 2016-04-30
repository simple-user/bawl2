//
//  CommentBox.h
//  net
//
//  Created by Admin on 22.02.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "User.h"
#import "AvatarView.h"


@protocol CommentBoxButtonsDelegate <NSObject>

-(void)avatarButtonTouchUpInside:(UIButton*)sender;
-(void)nameButtonTouchUpInside:(UIButton*)sender;
-(void)messageButtonTouchUpInside:(UIButton*)sender;

@end


@interface CommentBox : UIView


@property(strong, nonatomic)User *user;
// by tapping name on description we will passing to frofile.
// in the first variant of code, segwey passed only userID.
// but this coused to request all users on profile and find our user in array
// so, i think it will be more constructive to pass User Object
@property(nonatomic)NSNumber *issueID;


@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSString *message;

@property(strong, nonatomic) NSString *avatarStringName;
@property(strong, nonatomic) UIImage *avatarImage;
@property(nonatomic) CGFloat avatarHeightWidth;

@property(strong, nonatomic) id <CommentBoxButtonsDelegate> buttonsDelegate;

@property(nonatomic)NSUInteger index;
@property(nonatomic)BOOL isBig;
@property(nonatomic)BOOL isNeedResize;
@property(nonatomic)CGFloat messageBigHeight;
@property(nonatomic)CGFloat messageSmallHeight;




-(instancetype)init;

-(void)fillWithName:(NSString*)name
         andMessage:(NSString*)message
andAvatarStringName:(NSString*)avatarStringName
      andAvatarHeightWidth:(CGFloat)avatarHeightWidth
 andButtonsDelegate:(id)delegate
           andIndex:(NSUInteger)index
          andUser:(User*)user;





@end
