//
//  BPPointHistory.m
//  net
//
//  Created by Admin on 05.01.16.
//  Copyright (c) 2016 Admin. All rights reserved.
//

#import "IssueHistoryAction.h"

@implementation IssueHistoryAction


-(NSString*)description
{
    return [NSString stringWithFormat:@"UserId - %@, made an action - %@, at:%@", self.userId, self.action, self.stringDate];
}



-(instancetype)initWithDictionary:(NSDictionary*)dic;
{
    if(self = [super init])
    {
        _action = dic[@"ACTION"];
        _stringDate = dic[@"DATE"];
        _userId = dic[@"USER_ID"];
    }
    return self;
}

@end
