//
//  MyAlert.h
//  bawl2
//
//  Created by Admin on 10.04.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyAlert : NSObject

+(void)alertWithTitle:(NSString*)title andMessage:(NSString*)message andButton:(NSString*)button;
+(void)alertWithTitle:(NSString*)title andMessage:(NSString*)message;
+(void)alertWithMessage:(NSString*)message;


@end
