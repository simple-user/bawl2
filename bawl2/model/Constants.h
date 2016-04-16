//
//  NotificationsNames.h
//  net
//
//  Created by Admin on 27.03.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#ifndef Constants_h
#define Constants_h


#pragma mark - my notificstions

#define MyNotificationManagedObjectDidInit @"ManagedObjectDdidInitNotification"
#define MyNotificationIssueCategoriesDidLoad @"IssueCategoriesDidLoadNotification" 
#define MyNotificationUserCheckedAndLogIned @"UserCheckedAndLogIned"
#define MyNotificationUploadIssueImageInfo @"UploadIssueImageInfo"

#pragma mark - Segue identificators

#define MySegueFromMapToLogIn @"FromMapToLogIn"
#define MySegueFromMapToDescription @"FromMapToDescription"
#define MySegueFromMapToProfile @"FromMapToProfile"
#define MySegueFromDescriptionToHistory @"FromDescriptionToHistory"
#define MySegueFromDescriptionToProfile @"FromDescriptionToProfile"
#define MySegueFromMapToNewItemModal @"fromMapToNewItem"
#define MySegueFromNewIssueToGetPhoto @"FromNewIssueToGetPhoto"

#pragma mark - default names for blank images (user, issue)

#define ImageNameForBLankUser @"defaultUser"
#define ImageNameForBLankIssue @"defaultIssue"

#pragma mark - manes of requests (for active requests)

#define ActiveRequestCheckCurrentUser @"check current user"


#pragma mark - CustomSell

#define CustomCellName @"name"
#define CustomCellCategory @"category"

#pragma mark - names dof keys in custom dictionaries
#define CustomDictionaryKeyUploadIssueImageInfoForProgress @"UploadIssueImageInfoForProgress"

#endif /* NotificationsNames_h */
