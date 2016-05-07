//
//  Comment.m
//  net
//
//  Created by Admin on 18.02.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "Comment.h"
#import "NetworkDataSorce.h"
#import "CDUser.h"
#import "CurrentItems.h"
#import "Constants.h"

@implementation Comment

//{
//    "USER_ID": 1,
//    "COMMENT": "Text of comment",
//    "DATE": "01/01/2016"
//}



-(instancetype)initWithCommentDictionary:(NSDictionary <NSString*,id> *)commentDictionary
                             andUser:(User *)user
                          andComentBox:(CommentBox*)commentBox
                      andImageDictionary:(NSMutableDictionary <NSString*, UIImage*> *) dictionary
{
    if(self = [super init])
    {
        id<DataSorceProtocol> datasorce = [[NetworkDataSorce alloc] init];
        
        _userId = [commentDictionary objectForKey:@"USER_ID"];
        _userMessage = [commentDictionary objectForKey:@"COMMENT"];

        if(user == nil)
        {
            _userName = @"Deleted User";
            commentBox.avatarImage = [UIImage imageNamed:@"deletedUser"];
        }
        else
        {
            _userName = user.name;
            NSString *avatarStringName = user.avatar;
            UIImage *avatarImageFromDic = [dictionary objectForKey:avatarStringName];
            // if there is no such file name in or dictionary - so image hasn't downloaded yet!
            if (avatarImageFromDic==nil)
            {
                [dictionary setObject:(UIImage*)[NSNull null] forKey:avatarStringName];
                [datasorce requestImageWithName:avatarStringName  andImageType:ImageNameSimpleUserImage andHandler:^(UIImage *downloadedImage, NSError *error) {
                    _userImage = downloadedImage;
                    CurrentItems *ci = [CurrentItems sharedItems];
                    [ci.managedObjectContext performBlock:^{
                        [CDUser setAvatar:downloadedImage forCDUserFromUser:user withContext:ci.managedObjectContext];
                    }];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // we don't update current image, because it will be updated with notification
                        [dictionary setObject:downloadedImage forKey:avatarStringName];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAvatarImages" object:nil userInfo:@{avatarStringName : downloadedImage}];
                    });
                }];
            }
            // if we have image already downloaded. (not nil and not [NSNull null])
            // so just set it to image
            else if (![avatarImageFromDic isKindOfClass:[NSNull class]])
            {
                commentBox.avatarImage = avatarImageFromDic;
            }
        }
        
    }
    
    return self;
    
}


@end
