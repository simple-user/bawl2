//
//  CDIssue.m
//  
//
//  Created by Admin on 25.03.16.
//
//

#import "CDIssue.h"
#import "NetworkDataSorce.h"
#import "Constants.h"
#import "CDIssueHistoryAction.h"
#import "MyAlert.h"

@implementation CDIssue

// isn't nice...
+(NetworkDataSorce*)networkDataSorce
{
    static NetworkDataSorce *_networkDataSorce = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _networkDataSorce = [[NetworkDataSorce alloc] init];
    });
    return _networkDataSorce;
}


+(CDIssue*)syncFromIssue:(Issue*)issue withContext:(NSManagedObjectContext*)context
{
    
    CDIssue *cdIssue = nil;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"issueID = %@", issue.issueId];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"CDIssue"];
    request.predicate = predicate;
    
    NSError *error = nil;
    NSArray <CDIssue*> *cdIssues = [context executeFetchRequest:request error:&error];
    
    if(cdIssues == nil || error!= nil)
    {
        // request error
    }
    else if(cdIssues.count>1)
    {
        // dublicated id of issue
    }
    else if (cdIssues.count<1)
    {
        // add new Issue to Core Data
        cdIssue = [NSEntityDescription insertNewObjectForEntityForName:@"CDIssue" inManagedObjectContext:context];
        cdIssue.desc = issue.issueDescription;
        cdIssue.imageString = issue.attachments;
        cdIssue.issueID = issue.issueId;
        cdIssue.status = issue.status;
        cdIssue.latitude = issue.latitude;
        cdIssue.longitude = issue.longitude;
        cdIssue.category = issue.categoryId;
    }
    else
    {
        // we can check and modify some of properties
        cdIssue = [cdIssues firstObject];
        // for now we can't modify properties
    }
    
    return cdIssue;
}

+(void)updateImageforCDIssue:(CDIssue*)cdIssue
{
    [[CDIssue networkDataSorce] requestImageWithName:cdIssue.imageString
                                         andHandler:^(UIImage *image, NSError *error) {
                                             if (image!=nil)
                                             {
                                                 NSUInteger pos = cdIssue.imageString.length-3;
                                                 NSRange range = NSMakeRange(pos, 3);
                                                 NSString *fileExtension = [cdIssue.imageString substringWithRange:range];
                                                 if ([fileExtension isEqualToString:@"png"] || [cdIssue.imageString isEqualToString:ImageNameForBLankUser])
                                                 {
                                                     cdIssue.imageData = UIImagePNGRepresentation(image);
                                                     NSLog(@"Update issue image in CD (png) for avatar: %@", cdIssue.imageString);
                                                 }
                                                 else if ([fileExtension isEqualToString:@"jpg"])
                                                 {
                                                     cdIssue.imageData = UIImageJPEGRepresentation(image, 1.0);
                                                     NSLog(@"Update issue image in CD (jpg) for avatar: %@", cdIssue.imageString);
                                                     
                                                 }
                                                 else
                                                 {
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         [MyAlert alertWithTitle:@"Error in updateAvatarforCDUser" andMessage:[NSString stringWithFormat:@"file name is - %@", cdIssue.imageString]];
                                                     });
                                                 }
                                                 
                                             }
                                         }];
}

+(void)syncFromIssues:(NSArray<Issue*>*)issues withContext:(NSManagedObjectContext*)context
{
    for (Issue *issue in issues)
    {
        [CDIssue syncFromIssue:issue withContext:context];
    }
}

@end
