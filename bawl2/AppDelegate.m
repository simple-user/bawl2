//
//  AppDelegate.m
//  bawl2
//
//  Created by Admin on 29.03.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "AppDelegate.h"
#import "IssueCategories.h"
#import "CurrentItems.h"
#import "NetworkDataSorce.h"
#import "Constants.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [IssueCategories earlyPreparing];
    [[CurrentItems sharedItems] startInitManagedObjectcontext];
    return YES;
}


-(void)checkCurrentUser
{
    NSDictionary *userDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"userDictionary"];
    if(userDictionary!=nil)
    {
        CurrentItems *ci = [CurrentItems sharedItems];
        NetworkDataSorce *dataSorce = [[NetworkDataSorce alloc] init];
        NSURLSessionDataTask* requestDataTask = [dataSorce requestLogInWithUser:[userDictionary objectForKey:@"LOGIN"]
                                                                        andPass:[userDictionary objectForKey:@"PASSWORD"]
                    andViewControllerHandler:^(User *resUser, NSError *error)
         {
             dispatch_async(dispatch_get_main_queue(), ^ {
                 ci.user = resUser;
                 [ci.activeRequests removeObjectForKey:ActiveRequestCheckCurrentUser];
                 [[NSNotificationCenter defaultCenter] postNotificationName:MyNotificationUserCheckedAndLogIned object:nil];
             });
         }];
        [ci.activeRequests setObject:requestDataTask forKey:ActiveRequestCheckCurrentUser];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
