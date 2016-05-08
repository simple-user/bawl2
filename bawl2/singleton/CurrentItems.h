//
//  CurrentItems.h
//  net
//
//  Created by Admin on 14.02.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol UserImageDelegate <NSObject>

-(void)userImageDidLoad;
-(void)userImageDidFailedLoad;

@end

@protocol IssueImageDelegate <NSObject>

-(void)issueImageDidLoad;
-(void)issueImageDidFailedLoad;

@end

#import <UIKit/UIKit.h>
#import "User.h"
#import "Issue.h"
#import "ActiveRequest.h"

@interface CurrentItems : NSObject

@property(strong, nonatomic) User *user;
@property(strong, nonatomic) Issue *issue;
// @property(strong, nonatomic) NSArray <NSDictionary*> *issueHistroy;
@property(strong, nonatomic) UIImage *userImage;
@property(strong, nonatomic) UIImage *issueImage;
@property(strong, nonatomic) NSMutableArray<id<UserImageDelegate>> *userImageDelegates;
@property(strong, nonatomic) NSMutableArray<id<IssueImageDelegate>> *issueImageDelegates;
@property(strong, nonatomic) UIManagedDocument *managedDocument;
@property(strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property(strong, nonatomic) NSMutableDictionary <NSString*, ActiveRequest*> *activeRequests;

+(instancetype)alloc __attribute__((unavailable("not available, use sharedItems")));
-(instancetype)init __attribute__((unavailable("not available, use sharedItems")));
-(instancetype)copy __attribute__((unavailable("not available, use sharedItems")));
+(instancetype)new __attribute__((unavailable("not available, use sharedItems")));

+(instancetype)sharedItems;

-(void)setUserAndUpdateImage:(User*)user;
-(void)setIssueAndUpdateImage:(Issue *)issue;


-(void)startInitManagedObjectcontext;


@end
