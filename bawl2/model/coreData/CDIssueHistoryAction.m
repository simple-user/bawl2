//
//  CDIssueHistoryAction.m
//  bawl2
//
//  Created by Admin on 31.03.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "CDIssue.h"
#import "CDIssueHistoryAction.h"

@implementation CDIssueHistoryAction

+(CDIssueHistoryAction*)syncFromHistoryAction:(IssueHistoryAction*)historyAction
                                   forCDIssue:(CDIssue*)cdIssue
                                   withNumber:(NSNumber*)number
                                  withContext:(NSManagedObjectContext*)context;
{
    CDIssueHistoryAction *cdHistoryAction = nil;
    

    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"issue.issueID = %@ and actionNumber = %@", cdIssue.issueID, number];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"CDIssueHistoryAction"];
    request.predicate = predicate;
    
    NSError *error = nil;
    NSArray <CDIssueHistoryAction*> *cdHistoryActions = [context executeFetchRequest:request error:&error];
    
    if(cdHistoryActions == nil || error != nil)
    {
        // error
    }
    else if (cdHistoryActions.count > 1)
    {
        // dublidated items
    }
    else if (cdHistoryActions.count < 1)
    {
        //creating
        cdHistoryAction = [NSEntityDescription insertNewObjectForEntityForName:@"CDIssueHistoryAction" inManagedObjectContext:context];
        cdHistoryAction.action = historyAction.action;
        cdHistoryAction.stringDate = historyAction.stringDate;
        cdHistoryAction.userID = historyAction.userId;
        cdHistoryAction.actionNumber = number;
        cdHistoryAction.issue = cdIssue;
    }
    else
    {
        cdHistoryAction = [cdHistoryActions firstObject];
        // renew if needed
        if (![cdHistoryAction.action isEqualToString:historyAction.action])
            cdHistoryAction.action = historyAction.action;
       
        if(![cdHistoryAction.stringDate isEqualToString:historyAction.stringDate])
            cdHistoryAction.stringDate = historyAction.stringDate;
        
        if(![cdHistoryAction.userID isEqualToNumber:historyAction.userId])
            cdHistoryAction.userID = historyAction.userId;
    }
    
    return cdHistoryAction;
    
    
}

+(void)syncFromHistoryActions:(NSArray <IssueHistoryAction*> *)historyActions
                                    forCDIssue:(CDIssue*)cdIssue
                                   withContext:(NSManagedObjectContext*)context;

{
    NSUInteger number = 0;
    for (IssueHistoryAction * hAction in historyActions)
    {
        [CDIssueHistoryAction syncFromHistoryAction:hAction
                                           forCDIssue:cdIssue
                                         withNumber:[NSNumber numberWithInteger:number]
                                        withContext:context];
        ++number;
    }
}




@end
