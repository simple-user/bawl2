//
//  CDIssue.h
//  
//
//  Created by Admin on 25.03.16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Issue.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDIssue : NSManagedObject

+(CDIssue*)syncFromIssue:(Issue*)issue withContext:(NSManagedObjectContext*)context;
+(void)syncFromIssues:(NSArray<Issue*>*)issues withContext:(NSManagedObjectContext*)context;

@end

NS_ASSUME_NONNULL_END

#import "CDIssue+CoreDataProperties.h"
