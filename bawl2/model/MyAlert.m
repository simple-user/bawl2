//
//  MyAlert.m
//  bawl2
//
//  Created by Admin on 10.04.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "MyAlert.h"
#import <UIKit/UIKit.h>

@implementation MyAlert


+(void)alertWithTitle:(NSString*)title andMessage:(NSString*)message andButton:(NSString*)button
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:button otherButtonTitles:nil];
    [alert show];
    
}
+(void)alertWithTitle:(NSString*)title andMessage:(NSString*)message
{
    [MyAlert alertWithTitle:title andMessage:message andButton:@"OK"];
}
+(void)alertWithMessage:(NSString*)message
{
    [MyAlert alertWithTitle:@"Title" andMessage:message];
}


@end
