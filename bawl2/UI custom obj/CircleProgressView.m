//
//  CircleProgressView.m
//  bawl2
//
//  Created by Admin on 02.05.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "CircleProgressView.h"

@interface CircleProgressView()

// @property(nonatomic) CGPoint center; we have at superclass
@property(nonatomic) CGFloat radius;
@property(nonatomic) CGRect textRect;
@property(nonatomic) CGPoint boundsCenter;
@property(nonatomic) UIFont* fontOfText;


@end

@implementation CircleProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setUp];
}

-(void)setUp
{
    self.backgroundColor = [UIColor whiteColor];
    
    // font
    self.fontOfText = [UIFont fontWithName: @"Helvetica-Bold" size: self.fontSize];
    
    CGFloat height = self.bounds.size.height;
    CGFloat width =  self.bounds.size.width;
    CGFloat radius = ((width > height) ? height / 2 : width / 2) - self.innerOffset;
    self.boundsCenter = CGPointMake(width / 2, height / 2);
    
    // according to our line width
    self.radius = radius - (self.lineWidth / 2);
    
    // inner radius
    CGFloat innerRadius = radius - self.lineWidth;
    
    // Ax = Cx - R * sin(PI/4)
    CGFloat originXForText = self.boundsCenter.x - innerRadius * sinf(M_PI/4);
    
    CGFloat originYForText = self.boundsCenter.y - (self.fontOfText.pointSize / 2);
    
    CGFloat textWidth = (self.boundsCenter.x - originXForText) *2;
    CGFloat textHeight = self.fontOfText.pointSize;
    
    self.textRect = CGRectMake(originXForText, originYForText, textWidth, textHeight);
    
}

- (void)drawRect:(CGRect)rect
{
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath addArcWithCenter:self.boundsCenter
                          radius:self.radius
                      startAngle:self.startAngle
                        endAngle:(self.endAngle - self.startAngle) * (self.percent / 100.0) + self.startAngle
                       clockwise:YES];
    bezierPath.lineWidth = self.lineWidth;
    [self.lineColor setStroke];
    [bezierPath stroke];
    
    // text
    NSString* textContent = [NSString stringWithFormat:@"%lu", self.percent];
    CGRect textRect = self.textRect;
    [[UIColor blackColor] setFill];
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    
    NSDictionary *attributes = @{NSFontAttributeName : self.fontOfText,
                                NSParagraphStyleAttributeName: paragraph};
    [textContent drawInRect:textRect withAttributes:attributes];
    
//    [textContent drawInRect: textRect withFont: [UIFont fontWithName: @"Helvetica-Bold" size: 42.5] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentCenter];
}

@end
