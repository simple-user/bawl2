//
//  HistoryCell.h
//  bawl2
//
//  Created by Admin on 04.05.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *actionText;
@property (strong, nonatomic) IBOutlet UILabel *fullName;
@property (strong, nonatomic) IBOutlet UILabel *login;
@property (strong, nonatomic) IBOutlet UILabel *stringDate;

@end
