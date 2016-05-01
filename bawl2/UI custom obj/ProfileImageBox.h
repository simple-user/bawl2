//
//  ProfileImageBox.h
//  bawl2
//
//  Created by Admin on 01.05.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol ProfileImageBoxDelegate <NSObject>

-(void)profileImageBoxUpdatedImage:(UIImage*)image;

@end


@interface ProfileImageBox : NSObject

@property(strong, nonatomic)NSString *name;
@property(strong, nonatomic)NSMutableArray < id <ProfileImageBoxDelegate> > *subscribersImageLoad;

-(instancetype)initWithName:(NSString*)name;

-(void)updateImageForSubscribersWithImage:(UIImage*)image;

@end
