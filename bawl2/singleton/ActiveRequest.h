//
//  ActiveRequest.h
//  bawl2
//
//  Created by Admin on 30.04.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActiveRequest : NSObject

@property(strong, nonatomic)NSString *name;
@property(strong, nonatomic)NSURLSessionDataTask *dataTask;

-(instancetype)initWithName:(NSString*)name andDataTask:(NSURLSessionDataTask*)dataTask;

@end
