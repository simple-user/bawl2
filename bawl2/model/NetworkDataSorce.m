//
//  NetworkDataSorce.m
//  net
//
//  Created by Admin on 10.01.16.
//  Copyright (c) 2016 Admin. All rights reserved.
//

#import "NetworkDataSorce.h"
#import "HTTPConnector.h"
#import "User.h"
#import "Issue.h"
#import "Parser.h"
#import "CurrentItems.h"

#import "CDUser.h"
#import "CDIssue.h"
#import "CDIssueHistoryAction.h"

#import "Constants.h"

#import <CoreText/CTFontManager.h>

@interface NetworkDataSorce()



@end


@implementation NetworkDataSorce




-(void)requestCategories:(void (^)(NSArray<IssueCategory*> * issueCategories, NSError *error))viewControllerHandler
{
    HTTPConnector *connector = [[HTTPConnector alloc] init];
    [connector requestCategories:^(NSData *data, NSError *error) {
        NSMutableArray <IssueCategory*> *issueCategories = nil;
        if (data.length > 0 && error==nil)
        {
            NSArray <NSDictionary*> *issueCategoryDics = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            issueCategories = [[NSMutableArray alloc] init];
            
            for(NSDictionary *issueCategoryDic in issueCategoryDics)
            {
                IssueCategory *issueCategory = [[IssueCategory alloc] initWithDictionary:issueCategoryDic];
                [issueCategories addObject:issueCategory];
            }
        }
        viewControllerHandler(issueCategories, error);

    }];

}


-(void)requestAllUsers:(void (^)(NSArray <User *> *users, NSError *error))handler
{
    HTTPConnector *connector = [[HTTPConnector alloc] init];
    [connector requestUsers:^(NSData *data, NSError *error) {
        NSArray <NSDictionary<NSString*,NSString*>*> *userDics = nil;
        NSMutableArray <User*> *users = nil;
        if(data.length>0 && error==nil)
        {
            userDics= [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (![userDics isKindOfClass:[NSArray class]] || error != nil)
            {
                userDics=nil;
            }
            else
            {
                users = [[NSMutableArray alloc] init];
                for (NSDictionary *userDic in userDics)
                {
                    User *u = [[User alloc] initWitDictionary:userDic];
                    [users addObject:u];
                }
                CurrentItems *ci = [CurrentItems sharedItems];
                if (ci.managedObjectContext != nil)
                {
                    [CDUser syncFromUsers:users withContext:ci.managedObjectContext];
                }
            }
            
            
        }
        handler(users, error);
    }];
}

-(void)requestAllIssues:(void (^)(NSArray <Issue *> *issues, NSError *error))handler
{
    HTTPConnector *connector = [[HTTPConnector alloc] init];
    [connector requestIssues:^(NSData *data, NSError *error) {
        
        NSArray <NSDictionary*> *issueDics = nil;
        NSMutableArray <Issue*> *issues = nil;
        
        if(data.length>0 && error == nil)
        {
            issueDics = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if(![issueDics isKindOfClass:[NSArray class]] || error!=nil)
            {
                issueDics=nil;
            }
            else
            {
                issues = [[NSMutableArray alloc] init];
                for (NSDictionary *issueDic in issueDics)
                {
                    Issue *i = [[Issue alloc] initWithDictionary:issueDic];
                    [issues addObject:i];
                }
                CurrentItems *ci = [CurrentItems sharedItems];
                if(ci.managedObjectContext!=nil)
                {
                    [ci.managedObjectContext performBlock:^{
                        for (Issue *issue in issues)
                        {
                            CDIssue *tempCDIssue = [CDIssue syncFromIssue:issue withContext:ci.managedObjectContext];
                            [CDIssueHistoryAction syncFromHistoryActions:issue.historyActions
                                                              forCDIssue:tempCDIssue
                                                             withContext:ci.managedObjectContext];
                        }
                       
                    }];
                }
            }
        }
        handler(issues, error);
    }];
}


-(void)requestCommentsWithIssueID:(NSNumber*)issueID
                       andHandler:(void (^)(NSArray <NSDictionary <NSString*,id> *> *commentDics, NSError *error))handler;
{
    HTTPConnector *connector = [[HTTPConnector alloc] init];
    [connector requestCommentWithID:[issueID stringValue] andDataSorceHandler:^(NSData *data, NSError *error) {
        if(error!=nil || data==nil)
        {
            handler(nil, error);
            return;
        }
        
        NSArray <NSDictionary<NSString*,id>*> *commentDics = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        handler(commentDics, error);

    }];
    
}

-(void)requestSendNewComment:(NSString*)strComment forIssueID:(NSNumber*)issueID
                  andHandler:(void (^)(NSArray <NSDictionary <NSString*,id> *> *commentDics, NSError *error))handler
{
    NSDictionary *dictionary = @{@"comment" : strComment};
    NSError *err;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                       options:0
                                                         error:&err];
    
    HTTPConnector *con = [[HTTPConnector alloc] init];
    [con requestSendNewCommentWithIssueID:[issueID stringValue] andPosData:postData andDatasorceHandler:^(NSData *data, NSError *error) {
        if(error!=nil || data==nil)
        {
            handler(nil, error);
            return;
        }
        
        NSArray <NSDictionary<NSString*,id>*> *commentDics = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        handler(commentDics, error);
    }];
    

}


-(void)requestImageWithName:(NSString*)name andImageType:(NSString*)imageType andHandler:(void (^)(UIImage *image, NSError *error))viewControllerHandler
{
    
    CurrentItems *ci = [CurrentItems sharedItems];
    ActiveRequest *activeRequest = nil;
    //stop previous if it exists
    if([imageType isEqualToString:ImageNameCurrentUserImage])
    {
        activeRequest = [ci.activeRequests objectForKey:ActiveRequestGetCurrentUserImage];
        if(activeRequest!=nil) // if exists -> stop
        {
            [activeRequest.dataTask cancel];
            NSLog(@"_requestImageWithName_: Download user image canceled! (filename:%@)", activeRequest.name);
        }
    }
    else if([imageType isEqualToString:ImageNameCurrentIssueImage])
    {
        activeRequest = [ci.activeRequests objectForKey:ActiveRequestGetCurrentIssueImage];
        if(activeRequest!=nil)
        {
            [activeRequest.dataTask cancel];
            NSLog(@"_requestImageWithName_: Download issue image canceled! (filename:%@)",  activeRequest.name);
        }
    }

    //download new image (or get local)
    NSURLSessionDataTask *dataTask = nil;
    if([name isEqualToString:ImageNameForBLankUser])
    {
        NSLog(@"_requestImageWithName_: local file for blank user (filename:%@)", name);
        viewControllerHandler([UIImage imageNamed:ImageNameNoUser], nil);
    }
    else if ([name isEqualToString:ImageNameForBLankIssue])
    {
        NSLog(@"_requestImageWithName_: local file for blank issue (filename:%@)", name);
        viewControllerHandler([UIImage imageNamed:ImageNameNoIssue], nil);
    }
    else if([name isEqual:[NSNull null]])
    {
        // it can't get here, because [NSNull null] is replaced in init methods
        // but for safety...
        // it can be either blank user and blank issue
        // so we need to check type
        NSLog(@"_requestImageWithName_: local file for [NSNull null]");
        if([imageType isEqualToString:ImageNameCurrentUserImage] || [imageType isEqualToString:ImageNameSimpleUserImage])
            viewControllerHandler([UIImage imageNamed:ImageNameNoUser], nil);
        else if ([imageType isEqualToString:ImageNameCurrentIssueImage] || [imageType isEqualToString:ImageNameSimpleIssueImage])
            viewControllerHandler([UIImage imageNamed:ImageNameNoUser], nil);
    }
    else
    {
        HTTPConnector *connector = [[HTTPConnector alloc] init];
        
        dataTask = [connector requestImageWithName:name andDataSorceHandler:^(NSData *data, NSError *error) {
            UIImage *image = nil;
            // logic:
            //   if it's cancel - we won't call controller handler and won't remove active request (it's already removed, and created new one)
            //   otherwise:
            //     we remove active request (because it's complited (even with error)) and call controller handler
            //     if we don't have errors - we will create image and pass it to controller handler
            //     (when we got error and pass image to handler - we pass nil, so controller will use no_attach for this issue and it won't be blank)
            if(error !=  nil && error.code==NSURLErrorCancelled)
            {
                NSLog(@"_requestImageWithName_: error code = canceled");
            }
            else
            {
                if (data.length > 0 && error==nil)
                {
                    image = [[UIImage alloc] initWithData:data];
                    
                }
                // here dowloading is complited, so we can del dataTask
                if([imageType isEqualToString:ImageNameCurrentUserImage])
                {
                    ActiveRequest *ar = [ci.activeRequests objectForKey:ActiveRequestGetCurrentUserImage];
                    if (ar != nil)
                    {
                        [ci.activeRequests removeObjectForKey:ActiveRequestGetCurrentUserImage];
                        NSLog(@"_requestImageWithName_: Download user image done! (filename:%@)", ar.name);
                    }
                    else
                    {
                        NSLog(@"_requestImageWithName_: Download user image done! BUT WE DIDN'T FIND ACTIVE REQUEST");
                    }
                }
                else if([imageType isEqualToString:ImageNameCurrentIssueImage])
                {
                    ActiveRequest *ar = [ci.activeRequests objectForKey:ActiveRequestGetCurrentIssueImage];
                    if (ar != nil)
                    {
                        [ci.activeRequests removeObjectForKey:ActiveRequestGetCurrentIssueImage];
                        NSLog(@"_requestImageWithName_: Download issue image done! (filename:%@)", ar.name);
                    }
                    else
                    {
                        NSLog(@"_requestImageWithName_: Download issue image done! BUT WE DIDN'T FIND ACTIVE REQUEST");
                    }
                }
                viewControllerHandler(image, error);
            }
        }];
    }
    
    // hook info if it's currrent user image or current issue image
    // but we are doing it only if data task is not nil!
    // otherwise is seems we've took local file
    if(dataTask != nil)
    {
        if([imageType isEqualToString:ImageNameCurrentUserImage])
        {
            activeRequest = [[ActiveRequest alloc] initWithName:name andDataTask:dataTask];
            [ci.activeRequests setObject:activeRequest forKey:ActiveRequestGetCurrentUserImage];
            NSLog(@"_requestImageWithName_: New download user image data task added! (filename:%@)", name);
        }
        else if([imageType isEqualToString:ImageNameCurrentIssueImage])
        {
            activeRequest = [[ActiveRequest alloc] initWithName:name andDataTask:dataTask];
            [ci.activeRequests setObject:activeRequest forKey:ActiveRequestGetCurrentIssueImage];
            NSLog(@"_requestImageWithName_: New download issue image data task added! (filename:%@)", name);
        }
    }
    
}


-(void)requestSignOutWithHandler:(void (^)(NSString * stringAnswer, NSError *error))viewControllerHandler
{
    HTTPConnector *wizard = [[HTTPConnector alloc] init];
    [wizard requestSignOutWithHandler:^(NSData *data, NSError *error) {
        NSString *resStr = nil;
        if (data.length > 0 && error==nil)
        {
            resStr = [Parser parseAnswer:data andReturnObjectForKey:@"message"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userDictionary"];
            // if user tapped Log out during avatar downloading - then we can cancel data task, and remove active request
            ActiveRequest *ar = [[CurrentItems sharedItems].activeRequests objectForKey:ActiveRequestGetCurrentUserImage];
            if(ar != nil)
            {
                [ar.dataTask cancel];
                [[CurrentItems sharedItems].activeRequests removeObjectForKey:ActiveRequestGetCurrentUserImage];
            }
        }
        viewControllerHandler(resStr, error);

    }];
}


-(void)requestLogInWithUser:(NSString*)login
                                     andPass:(NSString*)password
   andViewControllerHandler:(void (^)(User *resPerson, NSError *error))viewControllerHandler{
    
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                login, @"login",
                                password, @"password", nil];
    NSError *err;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                       options:0
                                                         error:&err];
    
    HTTPConnector *connector = [[HTTPConnector alloc] init];
    CurrentItems *ci = [CurrentItems sharedItems];
    ActiveRequest *activeRequest = nil;
    NSURLSessionDataTask* dataTask = [connector requestLogInWithData:postData
             andDataSorceHandler:^(NSData *data, NSError *error) {
                 User *tempUser = nil;
        if(data.length >0 && error == nil)
        {
            
            NSMutableDictionary *userDic = [[NSJSONSerialization JSONObjectWithData:data
                                                                            options:0
                                                                              error:NULL] mutableCopy];
            if([userDic count]>1)
            {
                if ([[userDic objectForKey:@"AVATAR"] isEqual:[NSNull null]])
                    [userDic setObject:ImageNameForBLankUser forKey:@"AVATAR"];
                [[NSUserDefaults standardUserDefaults] setObject:userDic forKey:@"userDictionary"];
                tempUser = [[User alloc] initWitDictionary:userDic];
            }
        }
        // here reques is done, so we can remove info from singleton active requests
        ActiveRequest *ar = [ci.activeRequests objectForKey:ActiveRequestLogInUser];
        if (ar != nil)
        {
         [ci.activeRequests removeObjectForKey:ActiveRequestLogInUser];
         NSLog(@"_requestLogInWithUser_: Logging done! (user name:%@)", ar.name);
        }
        else
        {
         NSLog(@"_requestLogInWithUser_: Logging done! BUT WE DIDN'T FIND ACTIVE REQUEST");
        }
        viewControllerHandler(tempUser, error);
        }];
    // hook previous data task, and stop it if it exists
    activeRequest = [ci.activeRequests objectForKey:ActiveRequestLogInUser];
    if(activeRequest!=nil) // if exists -> stop
    {
        [activeRequest.dataTask cancel];
        NSLog(@"_requestLogInWithUser_: Logging canceled! (user name:%@)",  activeRequest.name);
    }
    // then set new object for this value
    activeRequest = [[ActiveRequest alloc] initWithName:login andDataTask:dataTask];
    [ci.activeRequests setObject:activeRequest forKey:ActiveRequestLogInUser];
    NSLog(@"_requestLogInWithUser_: New logging user data task added! (user name:%@)", login);
}


-(void)requestSingUpWithUser:(User*)user
    andViewControllerHandler:(void (^)(User *resPerson, NSError *error))viewControllerHandler
{
    NSDictionary *dictionary = [user puckToDictionary];
    NSError *err;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                           options:0
                                                             error:&err];
    HTTPConnector *connector = [[HTTPConnector alloc] init];
    [connector requestSingUpWithData:postData
                 andDataSorceHandler:^(NSData *data, NSError *error) {
                     User *user = nil;
                     if(data.length >0 && error == nil)
                     {
                         NSMutableDictionary *userDic = [[NSJSONSerialization JSONObjectWithData:data
                                                                                   options:0
                                                                                     error:NULL] mutableCopy];

                         if([userDic count]>1)
                         {
                             [userDic setObject:ImageNameForBLankUser forKey:@"AVATAR"];
                             [[NSUserDefaults standardUserDefaults] setObject:userDic forKey:@"userDictionary"];
                             user = [[User alloc] initWitDictionary:userDic];
                             CurrentItems *ci = [CurrentItems sharedItems];
                             if(ci.managedObjectContext != nil)
                             {
                                 [CDUser syncFromUser:user withContext:ci.managedObjectContext];
                             }
                         }
                     }
                     viewControllerHandler(user, error);
                 }];
}



-(void)requestChangeStatusWithID:(NSNumber*)issueIdNumber
                        toStatus:(NSString*)stringStatus
        andViewControllerHandler:(void (^)(NSString *stringAnswer, Issue *issue, NSError *error))viewControllerHandler
{
    HTTPConnector *wizard = [[HTTPConnector alloc] init];
    NSData *postData = nil;
    
    if ([stringStatus isEqualToString:@"APPROVED"] || [stringStatus isEqualToString:@"CANCELED"])
    {
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:stringStatus, @"status", nil];
        postData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                           options:0
                                                             error:NULL];
    }
    
    [wizard requestChangeStatusWithStringIssueID:[NSString stringWithFormat:@"%@", issueIdNumber]
                                        toStatus:stringStatus
                                        withData:postData
                             andDataSorceHandler:^(NSData *data, NSError *error) {
        NSString *stringAnswer = nil;
        Issue *issue = nil;
        if (data.length > 0 && error==nil)
        {
            stringAnswer = [Parser parseAnswer:data andReturnObjectForKey:@"message"];
            
            if(stringAnswer == nil)
            {
                NSDictionary *issueDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                issue = [[Issue alloc] initWithDictionary:issueDictionary];
            }
        }
        viewControllerHandler(stringAnswer, issue, error);

    }];

}

-(void)requestSendImage:(UIImage*)image
                 ofType:(NSString*)type
                   kind:(NSString*)kind
            withHandler:(void(^)(NSString *fileName, NSError *error))handler;
{
    HTTPConnector *connector = [[HTTPConnector alloc] init];
    
    void(^handlerBlock)(NSData *data, NSError *error) =
    ^(NSData *data, NSError *error) {
        NSString *filename = nil;
        if (data.length > 0 && error == nil)
        {
            filename = [Parser parseAnswer:data andReturnObjectForKey:@"filename"];
        }
        handler(filename, error);
    };
    
    if ([kind isEqualToString:ImageKindIssue])
    {
        [connector requestSendIssueImage:image ofType:type andHandler:handlerBlock];
    }
    else if ([kind isEqualToString:ImageKindAvatar])
    {
        [connector requestSendAvatarImage:image ofType:type andHandler:handlerBlock];
    }
}

-(void)requestAddNewIssue:(Issue*)issue
              withHandler:(void(^)(Issue *returnedIssue, NSError *error))handler
{
    NSDictionary *dic = @{@"name" : issue.name,
                          @"desc" : issue.issueDescription,
                          @"point" : issue.mapPointer,
                          @"status" : @"NEW",
                          @"category" : issue.categoryId,
                          @"attach" : issue.attachments};
    NSError *err;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:0
                                                         error:&err];
    HTTPConnector *con = [[HTTPConnector alloc] init];
    [con requestSendNewIssue:postData withHandler:^(NSData *data, NSError *error) {
        Issue *issue = nil;
        if(data.length >0 && error == nil)
        {
            NSDictionary *issueDic = [NSJSONSerialization JSONObjectWithData:data
                                                                            options:0
                                                                              error:NULL];
            
            if([issueDic count]>1)
            {
                issue = [[Issue alloc] initWithDictionary:issueDic];
                CurrentItems *ci = [CurrentItems sharedItems];
                if(ci.managedObjectContext != nil)
                {
                    CDIssue *cdIssue = [CDIssue syncFromIssue:issue withContext:ci.managedObjectContext];
                    [CDIssueHistoryAction syncFromHistoryActions:issue.historyActions forCDIssue:cdIssue withContext:ci.managedObjectContext];
                }
            }
        }
        handler(issue, error);
    }];
    
    
}


@end
