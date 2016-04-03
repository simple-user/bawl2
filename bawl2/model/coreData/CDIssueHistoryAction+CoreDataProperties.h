//
//  CDIssueHistoryAction+CoreDataProperties.h
//  bawl2
//
//  Created by Admin on 02.04.16.
//  Copyright © 2016 Admin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDIssueHistoryAction.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDIssueHistoryAction (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *action;
@property (nullable, nonatomic, retain) NSNumber *actionNumber;
@property (nullable, nonatomic, retain) NSString *stringDate;
@property (nullable, nonatomic, retain) NSNumber *userID;
@property (nullable, nonatomic, retain) CDIssue *issue;

@end

NS_ASSUME_NONNULL_END
