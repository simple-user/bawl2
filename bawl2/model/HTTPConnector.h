//
//  BPHTTPWizard.h
//  net
//
//  Created by Admin on 05.01.16.
//  Copyright (c) 2016 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HTTPConnector : NSObject




// user
-(void)requestUsers:(void(^)(NSData *data, NSError *error))dataSorceHandler;

-(NSURLSessionDataTask*)requestLogInWithData:(NSData*)data
                         andDataSorceHandler:(void(^)(NSData *data, NSError *error))dataSorceHandler;

-(void)requestSingUpWithData:(NSData*)data
         andDataSorceHandler:(void(^)(NSData *data, NSError *error))dataSorceHandler;

-(void)requestSignOutWithHandler:(void (^)(NSData *data, NSError *error))dataSorceHandler;

-(void)requestUpdateUser:(NSUInteger)userId withData:(NSData*)data andDatasorceHandler:(void (^)(NSData* returnedData, NSError *error))datasorceHandler;


// issue
-(void)requestIssues:(void(^)(NSData *data, NSError *error))dataSorceHandler;

-(void)requestCategories:(void(^)(NSData *data, NSError *error))dataSorceHandler;

-(void)requestSendNewIssue:(NSData*)data
               withHandler:(void(^)(NSData* data, NSError *error))handler;

-(void)requestChangeStatusWithStringIssueID:(NSString*)strindIssueID
                                   toStatus:(NSString*)stringStatus
                                   withData:(NSData*)data
                        andDataSorceHandler:(void(^)(NSData *data, NSError *error))dataSorceHandler;


// comment
-(void)requestCommentWithID:(NSString*)strID andDataSorceHandler:(void(^)(NSData *data, NSError *error))dataSorceHandler;

-(void)requestSendNewCommentWithIssueID:(NSString*)strID
                             andPosData:(NSData*)data
                    andDatasorceHandler:(void(^)(NSData* data, NSError *error))dataSorceHandler;

// image
-(NSURLSessionDataTask*)requestImageWithName:(NSString*)name andDataSorceHandler:(void(^)(NSData *data, NSError *error))dataSorceHandler;

-(void)requestSendIssueImage:(UIImage*)image
                      ofType:(NSString*)type
                 andHandler:(void(^)(NSData *data, NSError *error))handler;

-(void)requestSendAvatarImage:(UIImage*)image
                      ofType:(NSString*)type
                  andHandler:(void(^)(NSData *data, NSError *error))handler;




@end
