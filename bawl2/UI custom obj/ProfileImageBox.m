//
//  ProfileImageBox.m
//  bawl2
//
//  Created by Admin on 01.05.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "ProfileImageBox.h"


@implementation ProfileImageBox

-(instancetype)initWithName:(NSString*)name
{
    if(self=[super init])
    {
        _name = name;
    }
    return self;
}


-(NSMutableArray < id <ProfileImageBoxDelegate> > *)subscribersImageLoad
{
    if(_subscribersImageLoad == nil)
    {
        _subscribersImageLoad = [[NSMutableArray alloc] init];
    }
    return _subscribersImageLoad;
}


-(void)updateImageForSubscribersWithImage:(UIImage *)image
{
    for (id<ProfileImageBoxDelegate> subscriber in self.subscribersImageLoad)
    {
        [subscriber profileImageBoxUpdatedImage:image];
    }
}

@end
