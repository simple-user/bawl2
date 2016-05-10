//
//  HistoryCell.m
//  bawl2
//
//  Created by Admin on 04.05.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "HistoryCell.h"

@interface HistoryCell()

@property (strong, nonatomic) IBOutlet UIButton *nameButton;

@end

@implementation HistoryCell


-(void)setIndexForButton:(NSUInteger)indexForButton
{
    self.nameButton.tag = indexForButton;
}

- (IBAction)nameButtonTapped:(UIButton *)sender
{
    [self.delegate nameTapedWithTag:self.nameButton.tag];
}


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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
