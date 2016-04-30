//
//  ActiveRequest.m
//  bawl2
//
//  Created by Admin on 30.04.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "ActiveRequest.h"

@implementation ActiveRequest

-(instancetype)initWithName:(NSString*)name andDataTask:(NSURLSessionDataTask*)dataTask
{
    if(self = [super init])
    {
        _name = name;
        _dataTask = dataTask;
    }
    return self;
}

@end
