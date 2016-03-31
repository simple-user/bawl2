//
//  CDIssue+CoreDataProperties.h
//  bawl2
//
//  Created by Admin on 31.03.16.
//  Copyright © 2016 Admin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDIssue.h"
@class CDIssueHistoryAction;

NS_ASSUME_NONNULL_BEGIN

@interface CDIssue (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *desc;
@property (nullable, nonatomic, retain) NSData *imageData;
@property (nullable, nonatomic, retain) NSString *imageString;
@property (nullable, nonatomic, retain) NSNumber *issueID;
@property (nullable, nonatomic, retain) NSString *status;
@property (nullable, nonatomic, retain) NSNumber *latitude;
@property (nullable, nonatomic, retain) NSNumber *longitude;
@property (nullable, nonatomic, retain) NSSet<CDIssueHistoryAction *> *historyActions;

@end

@interface CDIssue (CoreDataGeneratedAccessors)

- (void)addHistoryActionsObject:(CDIssueHistoryAction *)value;
- (void)removeHistoryActionsObject:(CDIssueHistoryAction *)value;
- (void)addHistoryActions:(NSSet<CDIssueHistoryAction *> *)values;
- (void)removeHistoryActions:(NSSet<CDIssueHistoryAction *> *)values;

@end

NS_ASSUME_NONNULL_END
