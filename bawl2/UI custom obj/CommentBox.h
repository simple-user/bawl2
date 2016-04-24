//
//  CommentBox.h
//  net
//
//  Created by Admin on 22.02.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AvatarView.h"


@protocol CommentBoxButtunsDelegate <NSObject>

-(void)avatarButtonTouchUpInside:(UIButton*)sender;
-(void)nameButtonTouchUpInside:(UIButton*)sender;

@end


@interface CommentBox : UIView


@property(strong, nonatomic)NSNumber *userID;
@property(nonatomic)NSNumber *issueID;


@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSString *message;

@property(strong, nonatomic) NSString *avatarStringName;
@property(strong, nonatomic) UIImage *avatarImage;
@property(nonatomic) CGFloat avatarHeightWidth;

@property(strong, nonatomic) id <CommentBoxButtunsDelegate> buttonsDelegate;

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
          andUserId:(NSNumber*)userID;





@end
