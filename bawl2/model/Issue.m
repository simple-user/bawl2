//
//  BPPoint.m
//  net
//
//  Created by Admin on 05.01.16.
//  Copyright (c) 2016 Admin. All rights reserved.
//

#import "Issue.h"
#import "Constants.h"

@interface Issue()
@property (nonatomic) CLLocationCoordinate2D coordinate;

@end

@implementation Issue

+(NSArray*)stringStatusesArray
{
    return @[@"NEW", @"APPROVED", @"CANCEL", @"TO_RESOLVE", @"RESOLVED"];
}

-(instancetype)initWithDictionary:(NSDictionary *)issueDictionary
{
    self = [super init];
    
    if (self) {
        _name = issueDictionary[@"NAME"];
        _issueId = issueDictionary[@"ID"];
        _attachments = issueDictionary[@"ATTACHMENTS"];
        _categoryId = issueDictionary[@"CATEGORY_ID"];
        _issueDescription = issueDictionary[@"DESCRIPTION"];
        _mapPointer = issueDictionary[@"MAP_POINTER"];
        _status = issueDictionary[@"STATUS"];
        [self addCoordinateInfo];
        NSArray <NSDictionary*> *historyDics = issueDictionary[@"HISTORY"];
        // if we have a dictionary, so we can just create an array of one
        // our server returs different types, wich depends on count of history actions
        if ([historyDics isKindOfClass:[NSDictionary class]])
            historyDics = @[historyDics];
        if (historyDics != nil)
        {
            NSMutableArray <IssueHistoryAction*> *mAr = [[NSMutableArray alloc] init];
            for(NSDictionary *historyDic in historyDics)
            {
                IssueHistoryAction *historyAction= [[IssueHistoryAction alloc] initWithDictionary:historyDic];
                [mAr addObject:historyAction];
            }
            _historyActions = mAr;
        }
        
        if ([_attachments isEqual:[NSNull null]]) {
            _attachments = ImageNameForBLankIssue;
        }
    }
    return self;
}

-(void)addCoordinateInfo
{
    _coordinate.latitude = [self.latitude doubleValue];
    _coordinate.longitude = [self.longitude doubleValue];
}

-(void)setCoordinate:(CLLocationCoordinate2D)coordinate
{
    _coordinate = coordinate;
}

-(NSNumber*)getNumberAsSubstringFromString:(NSString*)string BetweenString:(NSString*)str1 andString:(NSString*)str2
{
    NSNumber *result = nil;
    
    NSRange range1 = [self.mapPointer rangeOfString:str1];
    NSRange range2 = [self.mapPointer rangeOfString:str2];
    
    if (range1.location != NSNotFound && range2.location != NSNotFound)
    {
        NSUInteger len = range2.location - range1.location;
        NSString *substring =  [string substringWithRange:NSMakeRange(range1.location+1, len-1)];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        result = [formatter numberFromString:substring];
    }
    return result;
}

-(NSNumber*)longitude
{
    return [self getNumberAsSubstringFromString:self.mapPointer BetweenString:@"," andString:@")"];
}

-(NSNumber*)latitude
{
    return [self getNumberAsSubstringFromString:self.mapPointer BetweenString:@"(" andString:@","];
}

-(NSString*)title
{
    return self.name;
}

-(NSString*)subtitle
{
    return [NSString stringWithFormat:@"current status: %@", [self.status lowercaseStringWithLocale:[NSLocale currentLocale]]];
}


// this is just fog logging
-(NSString*)description
{
    return [NSString stringWithFormat:@"This is a point with name - %@, mapInfo - %@", self.name, self.mapPointer];
}

//// this is just for description method
//-(NSString*)pointHistoryToString;
//{
//    NSMutableString *mStr = [[NSMutableString alloc] init];
//    
//    for (IssueHistory *h in self.pointHistory)
//    {
//        [mStr appendString:[h description]];
//        [mStr appendString:@"\n"];
//    }
//    
//    if(mStr.length !=0)
//        [mStr deleteCharactersInRange:NSMakeRange([mStr length]-1,1)];
//    
//    return mStr;
//}


@end
