//
//  NewCommentView.m
//  bawl2
//
//  Created by Admin on 07.05.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "NewCommentView.h"

@interface NewCommentView()

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *textHeightConstraint;

@end

@implementation NewCommentView


#pragma mark - init

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
    self.textView.layer.cornerRadius = 6;
}


@end
