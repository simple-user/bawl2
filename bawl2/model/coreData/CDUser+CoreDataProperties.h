//
//  CDUser+CoreDataProperties.h
//  bawl2
//
//  Created by Admin on 02.04.16.
//  Copyright © 2016 Admin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDUser (CoreDataProperties)

@property (nullable, nonatomic, retain) NSData *avatarData;
@property (nullable, nonatomic, retain) NSString *avatarString;
@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSString *login;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *userId;

@end

NS_ASSUME_NONNULL_END
