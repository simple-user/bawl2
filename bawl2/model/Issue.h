//
//  BPPoint.h
//  net
//
//  Created by Admin on 05.01.16.
//  Copyright (c) 2016 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IssueHistoryAction.h"
#import <MapKit/MapKit.h>



@interface Issue : NSObject <MKAnnotation>

@property(strong, nonatomic)NSString *name;
@property (strong, nonatomic) NSNumber *issueId;
@property (strong, nonatomic) NSString *attachments;
@property (strong, nonatomic) NSString *categoryId;
@property (strong, nonatomic) NSString *issueDescription;
@property (strong, nonatomic) NSArray <IssueHistoryAction*> *historyActions;
@property (strong, nonatomic) NSString *mapPointer;
@property (strong, nonatomic) NSString *status;
// @property (strong, nonatomic) NSNumber *priorityId;

@property (strong, nonatomic, readonly) NSNumber *longitude; // just get method!!!
@property (strong, nonatomic, readonly) NSNumber *latitude;  // just get method!!!

// @property (nonatomic) CLLocationCoordinate2D coordinate;
//@property (strong,nonatomic,readonly) NSString *tittle;

@property (nonatomic, readonly, copy) NSString *title;       // just get method!!!
@property (nonatomic, readonly, copy) NSString *subtitle;    // just get method!!!


-(instancetype)initWithDictionary:(NSDictionary *)issueDictionary;
+(NSArray*)stringStatusesArray;


-(void)addCoordinateInfo;
@end








//typedef enum : NSUInteger {
//    NEW,
//    APPROVED,
//    CANCEL,
//    TO_RESOLVE,
//    RESOLVED,
//} Status;

 //@property(nonatomic, readonly)NSString *stringStatus;
 //
 //@property(nonatomic)NSUInteger pointId;
 //@property(nonatomic)Status statusEnum;
 //@property(strong, nonatomic)NSString *pDescription;
 //@property(strong, nonatomic)NSString *mapInfo;
 //@property(strong, nonatomic)NSArray *pointHistory; // of IssueHistory
 
 //{
 //    "ATTACHMENTS": "../img/attacments/incident01272.png",
 //    "CATEGORY_ID": "1",
 //    "DESCRIPTION": "Some big description to this issue",
 //    "ID": 2,
 //    "MAP_POINTER": "LatLng(50.622647, 26.265234)",
 //    "NAME": "Remove graffiti please",
 //    "PRIORITY_ID": 1,
 //    "STATUS": "TO_RESOLVE"
 //},
