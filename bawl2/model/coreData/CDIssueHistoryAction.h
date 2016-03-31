//
//  CDIssueHistoryAction.h
//  bawl2
//
//  Created by Admin on 31.03.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "IssueHistoryAction.h"

@class CDIssue;

NS_ASSUME_NONNULL_BEGIN

@interface CDIssueHistoryAction : NSManagedObject

// history action doesn't have its own ID. To to identify action we will use IssueID and number of action in history list (this has to be unique)
+(CDIssueHistoryAction*)syncFromHistoryAction:(IssueHistoryAction*)historyAction
                                     forCDIssue:(CDIssue*)cdIssue
                                   withNumber:(NSNumber*)number
                                  withContext:(NSManagedObjectContext*)context;

+(void)syncFromHistoryActions:(NSArray <IssueHistoryAction*> *)historyActions
                                    forCDIssue:(CDIssue*)cdIssue
                                  withContext:(NSManagedObjectContext*)context;

@end

NS_ASSUME_NONNULL_END

#import "CDIssueHistoryAction+CoreDataProperties.h"
