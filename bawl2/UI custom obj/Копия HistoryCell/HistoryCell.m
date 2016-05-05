//
//  HistoryCell.m
//  bawl2
//
//  Created by Admin on 04.05.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "HistoryCell.h"

@interface HistoryCell()


@end

@implementation HistoryCell

-(instancetype)init
{
    if(self = [super init])
        [self setUp];
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setUp];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
        [self setUp];
    return self;
}

-(void)setUp
{
    // self.translatesAutoresizingMaskIntoConstraints = NO;
}

@end
