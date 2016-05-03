//
//  DataSorceProtocol.h
//  net
//
//  Created by Admin on 10.01.16.
//  Copyright (c) 2016 Admin. All rights reserved.
//

#ifndef net_DataSorceProtocol_h
#define net_DataSorceProtocol_h
#import "User.h"
#import "Issue.h"
#import "IssueCategory.h"
#import <UIKit/UIKit.h>


@protocol DataSorceProtocol <NSObject>


// category
-(void)requestCategories:(void (^)(NSArray<IssueCategory*> * issueCategories, NSError *error))viewControllerHandler;

//user
-(void)requestAllUsers:(void (^)(NSArray <User *> *users, NSError *error))handler;

-(void)requestLogInWithUser:(NSString*)user
                    andPass:(NSString*)pass
   andViewControllerHandler:(void (^)(User *resPerson, NSError *error))viewControllerHandler;

-(void)requestSingUpWithUser:(User*)user
    andViewControllerHandler:(void (^)(User *resPerson, NSError *error))viewControllerHandler;

-(void)requestSignOutWithHandler:(void (^)(NSString * stringAnswer, NSError *error))viewControllerHandler;

-(void)requestUpdateUser:(User*)user andControllerHandler:(void (^)(User* returneduser, NSError *error))controllerHandler;



//issue
-(void)requestAllIssues:(void (^)(NSArray <Issue *> *issues, NSError *error))handler;

-(void)requestChangeStatusWithID:(NSNumber*)issueIdNumber
                        toStatus:(NSString*)stringStatus
        andViewControllerHandler:(void (^)(NSString *stringAnswer, Issue *issue, NSError *error))viewControllerHandler;

-(void)requestAddNewIssue:(Issue*)issue
              withHandler:(void(^)(Issue *returnedIssue, NSError *error))handler;

//comment
-(void)requestCommentsWithIssueID:(NSNumber*)issueID
                       andHandler:(void (^)(NSArray <NSDictionary <NSString*,id> *> *commentDics, NSError *error))handler;

-(void)requestSendNewComment:(NSString*)strComment forIssueID:(NSNumber*)issueID
                  andHandler:(void (^)(NSArray <NSDictionary <NSString*,id> *> *commentDics, NSError *error))handler;


// image
-(void)requestImageWithName:(NSString*)name andImageType:(NSString*)imageType andHandler:(void (^)(UIImage *image, NSError *error))viewControllerHandler;

-(void)requestSendImage:(UIImage*)image
                 ofType:(NSString*)type
                   kind:(NSString*)kind
            withHandler:(void(^)(NSString *fileName, NSError *error))handler;



@end


#endif
