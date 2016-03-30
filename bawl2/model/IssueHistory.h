//
//  BPPointHistory.h
//  net
//
//  Created by Admin on 05.01.16.
//  Copyright (c) 2016 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IssueHistory : NSObject


@property(strong, nonatomic)NSString * action;
@property(strong, nonatomic)NSString *stringDate;
@property(strong, nonatomic)NSNumber *userId;


-(instancetype)initWithDictionary:(NSDictionary*)dic;


@end
