//
//  NGGraphView.h
//  Nate Glenn
//
//  Created by Nate Glenn on 4/14/12.
//  Copyright (c) 2012 Nate Glenn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NGDataPoint;

@interface NGGraphView : UIView
{
    NSString *_title;
    NSString *_subTitle;
    int _segments;
    BOOL _showPoints;
    float _pointSize;
    UIColor *_pointColor;
    UIColor *_lineColor;
    CGFloat _lineWidth;
    NSMutableArray *_dataPoints;
    int _displayTotal;
    int _displayIncrement;
    NSArray *_linePoints;
    int _maxValue;
    int _minValue;
    float _xfactor;
    float _yfactor;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subTitle;
@property (nonatomic, readwrite) int segments;
@property (nonatomic, readwrite) BOOL showPoints;
@property (nonatomic, readwrite) float pointSize;
@property (nonatomic, retain) UIColor *pointColor;
@property (nonatomic, retain) UIColor *lineColor;
@property (nonatomic, readwrite) CGFloat lineWidth;
@property (nonatomic, retain) NSMutableArray *dataPoints;
@property (nonatomic) int displayTotal;
@property (nonatomic) int displayIncrement;
@property (nonatomic, readwrite) int maxValue;
@property (nonatomic, readwrite) int minValue;

- (void)drawText:(NSString *)message withContext:(CGContextRef)context atPoint:(CGPoint)cgPoint withSize:(float)textSize;
- (void)addDataPoint:(NGDataPoint *)dataPoint;

@end
