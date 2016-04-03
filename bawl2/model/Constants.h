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

#pragma mark - Segue identificators

#define MySequeFromMapToLogIn @"FromMapToLogIn"
#define MySequeFromMapToDescription @"FromMapToDescription"
#define MySequeFromMapToProfile @"FromMapToProfile"
#define MySequeFromDescriptionToHistory @"FromDescriptionToHistory"
#define MySequeFromDescriptionToProfile @"FromDescriptionToProfile"

#pragma mark - default names for blank images (user, issue)

#define ImageNameForBLankUser @"defaultUser"
#define ImageNameForBLankIssue @"defaultIssue"

#pragma mark - manes of requests (for active requests)

#define ActiveRequestCheckCurrentUser @"check current user"


#endif /* NotificationsNames_h */
