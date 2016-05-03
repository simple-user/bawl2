//
//  BPHTTPWizard.m
//  net
//
//  Created by Admin on 05.01.16.
//  Copyright (c) 2016 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTTPConnector.h"
#import "Constants.h"

@interface HTTPConnector() <NSURLSessionTaskDelegate>

@property(strong, nonatomic)NSString *globalURL;
@property(strong, nonatomic)NSString *allPersURL;
@property(strong, nonatomic)NSString *allIssues;
@property(strong, nonatomic)NSString *userLogIn;
@property(strong, nonatomic)NSString *userSingUp;
@property(strong, nonatomic)NSString *userSignOut;
@property(strong, nonatomic)NSString *changeIssueStatusToResolve;
@property(strong, nonatomic)NSString *changeIssueStatusToApproveCancel;
@property(strong, nonatomic)NSString *allCategories;
@property(strong, nonatomic)NSString *issueImage;
@property(strong, nonatomic)NSString *defaultIssueImage;
@property(strong, nonatomic)NSString *defaultUserImage;
@property(strong, nonatomic)NSString *comments;
@property(strong, nonatomic)NSString *addIssueImage;
@property(strong, nonatomic)NSString *addAvatarImage;
@property(strong, nonatomic)NSString *addNewIssue;
@property(strong, nonatomic)NSString *updateUser;


-(NSURLSessionDataTask*)postRequest:(NSData*) postData
             toURL:(NSString*) textUrl
        andHandler:(void(^)(NSData *data, NSError *error))handler;

-(NSURLSessionDataTask*)getRequestBlankToUrl:(NSString*)textUrl
                 andHandler:(void(^)(NSData* data, NSError *error))dataSorceHandler;

-(NSURLSessionDataTask*)putRequestToUrl:(NSString*)textUrl
              withData:(NSData *) data
                 andHandler:(void(^)(NSData* data, NSError *error))dataSorceHandler;

-(void)requestSendImage:(UIImage*)image
                 ofType:(NSString*)type
              toTextURL:(NSString*)textUrl
             andHandler:(void(^)(NSData *data, NSError *error))handler;

@end


@implementation HTTPConnector

-(instancetype)init
{
    if(self = [super init])
    {
        _globalURL = @"https://bawl-rivne.rhcloud.com/";
        _allPersURL = @"users/all";
        _allIssues = @"issue/all";
        _userLogIn = @"users/auth/login";
        _userSingUp = @"users";
        _userSignOut = @"users/auth/logout";
        _changeIssueStatusToResolve = @"issue/issueIDNumber/resolve";
        _changeIssueStatusToApproveCancel = @"issue";
        _allCategories = @"categories/all";
        _issueImage = @"image/";
        _defaultIssueImage = @"no_attach.png";
        _defaultUserImage = @"no_avatar.png";
        _comments = @"issue/commentIDNumber/comments";
        _addIssueImage = @"image/add/issue";
        _addAvatarImage = @"image/add/avatar";
        _addNewIssue = @"issue";
        _updateUser = @"users/userIDNumber";
        
    }
    return self;
}

-(void)requestSendIssueImage:(UIImage *)image ofType:(NSString *)type andHandler:(void (^)(NSData *, NSError *))handler
{
    [self requestSendImage:image ofType:type toTextURL:[self.globalURL stringByAppendingString:self.addIssueImage] andHandler:handler];
}

-(void)requestSendAvatarImage:(UIImage*)image ofType:(NSString*)type andHandler:(void(^)(NSData *data, NSError *error))handler
{
    [self requestSendImage:image ofType:type toTextURL:[self.globalURL stringByAppendingString:self.addAvatarImage] andHandler:handler];
}

-(void)requestIssues:(void(^)(NSData *data, NSError *error))dataSorceHandler
{
    [self getRequestBlankToUrl:[self.globalURL stringByAppendingString:self.allIssues] andHandler:dataSorceHandler];
}


-(void)requestUsers:(void(^)(NSData* data, NSError *error))dataSorceHandler
{
    [self getRequestBlankToUrl:[self.globalURL stringByAppendingString:self.allPersURL] andHandler:dataSorceHandler];
}

-(void)requestCategories:(void(^)(NSData *data, NSError *error))dataSorceHandler
{
    [self getRequestBlankToUrl:[self.globalURL stringByAppendingString:self.allCategories] andHandler:dataSorceHandler];
}
-(NSURLSessionDataTask*)requestImageWithName:(NSString*)name andDataSorceHandler:(void(^)(NSData *data, NSError *error))dataSorceHandler
{
    if ([name isEqual:[NSNull null]])
        name = self.defaultIssueImage;
    else if ([name isEqualToString:ImageNameForBLankUser])
        name = self.defaultUserImage;
    else if ([name isEqualToString:ImageNameForBLankIssue])
        name = self.defaultIssueImage;
        
    return [self getRequestBlankToUrl:[NSString stringWithFormat:@"%@%@%@", self.globalURL, self.issueImage, name] andHandler:dataSorceHandler];
}

-(void)requestCommentWithID:(NSString*)strID andDataSorceHandler:(void(^)(NSData *data, NSError *error))dataSorceHandler
{
    NSString *strUrl = [[self.globalURL stringByAppendingString:self.comments] stringByReplacingOccurrencesOfString:@"commentIDNumber" withString:strID];
    [self getRequestBlankToUrl:strUrl andHandler:dataSorceHandler];
}

-(void)requestSendNewCommentWithIssueID:(NSString*)strID
                             andPosData:(NSData*)data
                    andDatasorceHandler:(void(^)(NSData* data, NSError *error))dataSorceHandler
{
    NSString *strUrl = [[self.globalURL stringByAppendingString:self.comments] stringByReplacingOccurrencesOfString:@"commentIDNumber" withString:strID];
    [self postRequest:data toURL:strUrl andHandler:dataSorceHandler];
}

-(void)requestSendNewIssue:(NSData*)data
               withHandler:(void(^)(NSData* data, NSError *error))handler
{
    [self postRequest:data toURL:[self.globalURL stringByAppendingString:self.addNewIssue] andHandler:handler];
}


-(void)requestSignOutWithHandler:(void (^)(NSData *data, NSError *error))dataSorceHandler
{
    [self getRequestBlankToUrl:[self.globalURL stringByAppendingString:self.userSignOut] andHandler:dataSorceHandler];
}

-(NSURLSessionDataTask*)requestLogInWithData:(NSData*)data
                         andDataSorceHandler:(void(^)(NSData *data, NSError *error))dataSorceHandler;
{
    return [self postRequest:data toURL:[self.globalURL stringByAppendingString:self.userLogIn] andHandler:dataSorceHandler];
}

-(void)requestSingUpWithData:(NSData*)data
        andDataSorceHandler:(void(^)(NSData *data, NSError *error))dataSorceHandler;
{
    [self postRequest:data toURL:[self.globalURL stringByAppendingString:self.userSingUp] andHandler:dataSorceHandler];
}

-(void)requestUpdateUser:(NSUInteger)userId withData:(NSData*)data andDatasorceHandler:(void (^)(NSData* returnedData, NSError *error))datasorceHandler
{
    NSString *endOfURL = [self.updateUser stringByReplacingOccurrencesOfString:@"userIDNumber" withString:[NSString stringWithFormat:@"%lu", userId]];
    [self putRequestToUrl:[self.globalURL stringByAppendingString:endOfURL] withData:data andHandler:datasorceHandler];
}

-(void)requestChangeStatusWithStringIssueID:(NSString*)strindIssueID
                                   toStatus:(NSString*)stringStatus
                                   withData:(NSData*)data
                        andDataSorceHandler:(void(^)(NSData *data, NSError *error))dataSorceHandler
{
    if ([stringStatus isEqualToString:@"APPROVED"] || [stringStatus isEqualToString:@"CANCELED"])
    {
        [self putRequestToUrl:[NSString stringWithFormat:@"%@%@/%@", self.globalURL, self.changeIssueStatusToApproveCancel, strindIssueID]
                     withData:data
                   andHandler:dataSorceHandler];
    }
    else
    {
        [self putRequestToUrl:[[self.globalURL stringByAppendingString:self.changeIssueStatusToResolve] stringByReplacingOccurrencesOfString:@"issueIDNumber" withString:strindIssueID]
                     withData:nil
                   andHandler:dataSorceHandler];
    }
}


-(NSURLSessionDataTask*)postRequest:(NSData*) postData
             toURL:(NSString*) textUrl
        andHandler:(void(^)(NSData *data, NSError *error))handler
{
    NSURL *url = [NSURL URLWithString: textUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                     completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          // result with error (for testing)
                                          //        dataSorceHandler(data, [[NSError alloc] init]);
                                          handler(data, error);
                                      }
                                      ];
    
    [dataTask resume];
    return dataTask;
}

-(NSURLSessionDataTask*)getRequestBlankToUrl:(NSString*)textUrl andHandler:(void(^)(NSData* data, NSError *error))handler
{
    NSURL *url = [NSURL URLWithString:textUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                     completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          // result with error (for testing)
                                          //        dataSorceHandler(data, [[NSError alloc] init]);
                                          handler(data, error);
                                      }
                                      ];
    
    [dataTask resume];
    return dataTask;
}

    
-(NSURLSessionDataTask*)putRequestToUrl:(NSString*)textUrl
              withData:(NSData *) data
            andHandler:(void(^)(NSData* data, NSError *error))handler
{
    NSURL *url = [NSURL URLWithString: textUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"PUT"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    if(data != nil)
    {
        [request setHTTPBody:data];
    }
    
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                     completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          // result with error (for testing)
                                          //        dataSorceHandler(data, [[NSError alloc] init]);
                                          handler(data, error);
                                      }
                                      ];
    
    [dataTask resume];
    return dataTask;
}
    
-(void)requestSendImage:(UIImage*)image
                 ofType:(NSString*)type
              toTextURL:(NSString*)textUrl
             andHandler:(void(^)(NSData *data, NSError *error))handler
{
    NSData *data = nil;
    NSString *imageContentType = nil;
    if([type caseInsensitiveCompare:@"jpg"] == NSOrderedSame)
    {
        data = UIImageJPEGRepresentation(image, 1.0);
        imageContentType = @"image/jpeg";
    }
    else // png :)
    {
        data = UIImagePNGRepresentation(image);
        imageContentType = @"image/png";
    }
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    NSURL *url = [NSURL URLWithString: textUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"image.%@\"\r\n", type] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", imageContentType] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:data];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];

    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.sharedContainerIdentifier = textUrl;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config
                                                          delegate:self
                                                     delegateQueue:nil];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:
                                      ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                          NSDictionary *testDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                                          NSLog(@"\n\n------Result of uploading image ------\n%@\n----------------",testDic);
                                          handler(data, error);
                                      }];
    [dataTask resume];
    
    
    
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    float progress = (double)totalBytesSent / (double)totalBytesExpectedToSend;
    
    NSString *avatar = [self.globalURL stringByAppendingString:self.addAvatarImage];
    NSString *issue = [self.globalURL stringByAppendingString:self.addIssueImage];
    
    
    if([session.configuration.sharedContainerIdentifier isEqualToString:issue])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:MyNotificationUploadIssueImageInfo
                                                        object:self userInfo:@{CustomDictionaryKeyUploadIssueImageInfoForProgress : [NSNumber numberWithFloat:progress]}];
    }
    else if ([session.configuration.sharedContainerIdentifier isEqualToString:avatar])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:MyNotificationUploadAvatarImageInfo
                                                            object:self userInfo:@{CustomDictionaryKeyUploadAvatarImageInfoForProgress : [NSNumber numberWithFloat:progress]}];
    }
    
}

@end
