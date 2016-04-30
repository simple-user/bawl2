//
//  ProfileImageBox.m
//  bawl2
//
//  Created by Admin on 01.05.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "ProfileImageBox.h"


@implementation ProfileImageBox

-(instancetype)initWithName:(NSString*)name andImage:(UIImage*)image
{
    if(self=[super init])
    {
        _name = name;
        _image = image;
    }
    return self;
}

-(void)setImage:(UIImage *)image
{
    _image = image;
    [self.delegate profileImageBoxUpdatedImage:image];
}


@end
