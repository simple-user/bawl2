//
//  CircleProgressView.h
//  bawl2
//
//  Created by Admin on 02.05.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleProgressView : UIView

@property (nonatomic) NSUInteger percent;
@property (nonatomic) CGFloat lineWidth;
@property (strong, nonatomic) UIColor *lineColor;

@property(nonatomic) CGFloat startAngle;
@property(nonatomic) CGFloat endAngle;

@property(nonatomic) CGFloat fontSize;
@property(nonatomic) CGFloat innerOffset;

@end
