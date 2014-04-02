//
//  NGGraphView.m
//  Nate Glenn
//
//  Created by Nate Glenn on 4/14/12.
//  Copyright (c) 2012 Nate Glenn. All rights reserved.
//

#import "NGGraphView.h"
#import "NGDataPoint.h"
#import <CoreText/CoreText.h>

#define NG_X_OFFSET 40
#define NG_Y_OFFSET 40
#define NG_POINT_INSET 20
#define NG_DATE_FORMAT @"MM/dd/yyyy"
#define NG_DATE_TIME_FORMAT @"MM/dd/yyyy hh:mm a"
#define NG_SHORT_DATE_FORMAT @"MMM dd"
#define NG_GRAPH_DOT_SIZE 8

@implementation NGGraphView

@synthesize title=_title;
@synthesize subTitle=_subTitle;
@synthesize segments=_segments;
@synthesize showPoints=_showPoints;
@synthesize pointSize=_pointSize;
@synthesize pointColor=_pointColor;
@synthesize lineColor=_lineColor;
@synthesize lineWidth=_lineWidth;
@synthesize dataPoints=_dataPoints;
@synthesize displayTotal=_displayTotal;
@synthesize displayIncrement=_displayIncrement;
@synthesize maxValue=_maxValue;
@synthesize minValue=_minValue;

- (void)addDataPoint:(NGDataPoint *)dataPoint
{
    if (!_dataPoints)
    {
        [self setDataPoints:[[NSMutableArray alloc] init]];
    }
    [[self dataPoints] addObject:dataPoint];
    
    NSMutableArray *points = [[NSMutableArray alloc] init];
    
    _maxValue = 0;
    _minValue = 0;
    
    for (NGDataPoint *dp in _dataPoints)
    {
        if ([dp count] > _maxValue) _maxValue = [dp count];
        if ([dp count] < _minValue) _minValue = [dp count];
    }
    
    _displayTotal = _maxValue - _minValue;
    
    if (_displayTotal < 5)
    {
        _displayIncrement = 1;
    }
    else
    {
        if (_displayIncrement == 0) _displayIncrement = 5;
    }
    if ([_dataPoints count] < 2)
    {
        _xfactor = (self.frame.size.width - ((NG_X_OFFSET + NG_POINT_INSET) * 2));
    }
    else
    {
        _xfactor = (self.frame.size.width - ((NG_X_OFFSET + NG_POINT_INSET) * 2)) / ([_dataPoints count] - 1);
    }
    
    _yfactor = (self.frame.size.height - (NG_Y_OFFSET * 2)) / _displayTotal;
    
    for (int i = 0; i < [self.dataPoints count]; i++)
    {
        CGFloat x_value = (i * _xfactor) + NG_X_OFFSET + NG_POINT_INSET;
        CGFloat y_value = (self.frame.size.height - (NG_Y_OFFSET * 2)) - (([[_dataPoints objectAtIndex:i] count]) * _yfactor);
        [points addObject:[NSValue valueWithCGPoint:CGPointMake(x_value, y_value)]];
    }
    
    _linePoints = (NSArray *)points;
    
    [self setNeedsDisplay];

}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext(); //get the graphics context
    CGContextSetRGBStrokeColor(ctx, 0.0, 0.0, 0.0, 1); //there are two relevant color states, "Stroke" -- used in Stroke drawing functions and "Fill" - used in fill drawing functions
    //now we build a "path"
    //you can either directly build it on the context or build a path object, here I build it on the context
    CGContextSetLineWidth(ctx, 2.0);
    CGContextMoveToPoint(ctx, NG_X_OFFSET, NG_Y_OFFSET);
    //add a line from 0,0 to the point 100,100
    CGContextAddLineToPoint(ctx, NG_X_OFFSET, self.frame.size.height - (NG_Y_OFFSET));
    CGContextMoveToPoint(ctx, NG_X_OFFSET, self.frame.size.height - (NG_Y_OFFSET));
    CGContextAddLineToPoint(ctx, self.frame.size.width - (NG_X_OFFSET), self.frame.size.height - (NG_Y_OFFSET));

    //"stroke" the outside border
    CGContextStrokePath(ctx);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:NG_SHORT_DATE_FORMAT];
    
    // create lines to show amount of behaviors
    CGContextSetLineWidth(ctx, 0.5);
    //for (int i = 0; i <= _displayTotal; i = i + _displayIncrement)
    //{
    //    CGContextMoveToPoint(ctx, X_OFFSET, (i * _yfactor) + Y_OFFSET);        
    //    CGContextAddLineToPoint(ctx, X_OFFSET + 10, (i * _yfactor) + Y_OFFSET);
    //}

    if (_dataPoints != nil)
    {
        if (_segments == 0)
        {
            _segments = 5;
        }
        _displayIncrement = _displayTotal / _segments;
        if (_displayIncrement < 1) _displayIncrement = 1;
        
        // show total amount of behaviors.
        if (_displayTotal > 0)
        {
            for (int i = 0; i <= _displayTotal; i = i + _displayIncrement)
            {
                if (i % _displayIncrement == 0)
                {
                    float offset;
                    if (i > 99)
                    {
                        offset = 15.0;
                    }
                    else if (i > 9)
                    {
                        offset = 22.0;
                    }
                    else 
                    {
                        offset = 30.0;
                    }
                    CGContextSetLineWidth(ctx, 0.5);
                    CGContextMoveToPoint(ctx, NG_X_OFFSET, (self.frame.size.height - NG_Y_OFFSET) - (i * _yfactor));
                    CGContextAddLineToPoint(ctx, self.frame.size.width - NG_X_OFFSET, (self.frame.size.height - NG_Y_OFFSET) - (i * _yfactor));
                    [self drawText:[NSString stringWithFormat:@"%d", i] withContext:ctx atPoint:CGPointMake(offset, (self.frame.size.height - NG_Y_OFFSET) - (i * _yfactor) + 5.0) withSize:14.0];
                }
            }
            
            if (_displayTotal % _displayIncrement != 0)
            {
                float offset = 25.0;
                if (_displayTotal > 9)
                {
                    offset = 22.0;
                }
                CGContextMoveToPoint(ctx, NG_X_OFFSET, NG_Y_OFFSET);
                CGContextAddLineToPoint(ctx, self.frame.size.width - NG_X_OFFSET, NG_Y_OFFSET);
                [self drawText:[NSString stringWithFormat:@"%d", _displayTotal] withContext:ctx atPoint:CGPointMake(offset, NG_Y_OFFSET + 5.0) withSize:14.0];
            }
        }
        
        /*
        // draw the horizontal gray lines.
        CGContextSetRGBStrokeColor(ctx, 0.5, 0.5, 0.5, 1.0);
        CGContextSetLineWidth(ctx, 0.5);
        
        if (_displayTotal > 0)
        {
            for (int i = 0; i <= _displayTotal; i = i + _displayIncrement)
            {
                CGContextMoveToPoint(ctx, X_OFFSET + 10, (self.frame.size.height - Y_OFFSET) - (i * _yfactor));
                CGContextAddLineToPoint(ctx, self.frame.size.width - X_OFFSET, (self.frame.size.height - Y_OFFSET) - (i * _yfactor));
                CGContextStrokePath(ctx);
            }
            if (_displayTotal % _displayIncrement != 0)
            {
                CGContextMoveToPoint(ctx, X_OFFSET, Y_OFFSET);        
                CGContextAddLineToPoint(ctx, self.frame.size.width - X_OFFSET, Y_OFFSET);
            }
        }
        */

        // draw top label
        if (_title != nil)
        {
            [self drawText:_title withContext:ctx atPoint:CGPointMake(2.0, 27.0) withSize:12.0];
        }
        
        // draw subtitle label
        if (_subTitle != nil)
        {
            [self drawVerticalText:_subTitle withContext:ctx atPoint:CGPointMake(5.0, (self.frame.size.height / 2) + 30.0)];
        }
        
        // create lines to show sessions
        [formatter setDateFormat:NG_SHORT_DATE_FORMAT];
        
        // draw session date labels.
        /*
        for (int i = 0; i < _sessionCount; i++)
        {
            // draw starting date...
            [self drawDiagonalText:[formatter stringFromDate:[[_dataPoints objectAtIndex:i] sessionDate]] withContext:ctx atPoint:CGPointMake(X_OFFSET + 20 + (i * _xfactor)- 27.0, self.frame.size.height - Y_OFFSET + 27.0)];
            
            CGContextMoveToPoint(ctx, (i * _xfactor) + X_OFFSET + POINT_INSET, self.frame.size.height - Y_OFFSET);
            CGContextAddLineToPoint(ctx, (i * _xfactor) + X_OFFSET + POINT_INSET, self.frame.size.height - (Y_OFFSET + 10));
        }
        */
        
        int i = 0;
        for (NGDataPoint *dataPoint in _dataPoints)
        {
            [self drawDiagonalText:dataPoint.label withContext:ctx atPoint:CGPointMake(NG_X_OFFSET + 20 + (i * _xfactor)- 27.0, self.frame.size.height - NG_Y_OFFSET + 27.0)];
            
            CGContextMoveToPoint(ctx, (i * _xfactor) + NG_X_OFFSET + NG_POINT_INSET, self.frame.size.height - NG_Y_OFFSET);
            CGContextAddLineToPoint(ctx, (i * _xfactor) + NG_X_OFFSET + NG_POINT_INSET, self.frame.size.height - (NG_Y_OFFSET + 10));
            i = i + 1;
        }
        
        CGContextStrokePath(ctx);
        
        CGFloat red, green, blue, alpha;
        if (![self lineColor])
        {
            [self setLineColor:[UIColor blueColor]];
        }
        [[self lineColor] getRed:&red green:&green blue:&blue alpha:&alpha];
        
        CGContextSetRGBStrokeColor(ctx, red, green, blue, alpha);
        if (_lineWidth == 0)
        {
            _lineWidth = 2.0;
        }
        CGContextSetLineWidth(ctx, _lineWidth);
        // Now draw the graph line.
        if ((_linePoints != nil) && ([_linePoints count] > 0))
        {
            NSValue *startPoint = [_linePoints objectAtIndex:0];
            CGContextMoveToPoint(ctx, [startPoint CGPointValue].x, [startPoint CGPointValue].y + NG_Y_OFFSET);
            
            for (NSValue *point in _linePoints)
            {
                CGContextAddLineToPoint(ctx, [point CGPointValue].x, [point CGPointValue].y + NG_Y_OFFSET);
            }            

            CGContextStrokePath(ctx);
            
            if (_showPoints)
            {
                if (_pointSize == 0)
                {
                    _pointSize = NG_GRAPH_DOT_SIZE;
                }
                if (!_pointColor)
                {
                    [self setPointColor:[UIColor blackColor]];
                }
                // draw squares for data points.
                for (NSValue *point in _linePoints)
                {
                    CGContextMoveToPoint(ctx, [point CGPointValue].x - (_pointSize / 2), [point CGPointValue].y - (_pointSize / 2) + NG_Y_OFFSET);
                    CGContextAddLineToPoint(ctx, [point CGPointValue].x + (_pointSize / 2), [point CGPointValue].y - (_pointSize / 2) + NG_Y_OFFSET);
                    CGContextAddLineToPoint(ctx, [point CGPointValue].x + (_pointSize / 2), [point CGPointValue].y + (_pointSize / 2) + NG_Y_OFFSET);
                    CGContextAddLineToPoint(ctx, [point CGPointValue].x - (_pointSize / 2), [point CGPointValue].y + (_pointSize / 2) + NG_Y_OFFSET);
                    CGContextAddLineToPoint(ctx, [point CGPointValue].x - (_pointSize / 2), [point CGPointValue].y - (_pointSize / 2) + NG_Y_OFFSET);
                    CGContextSetFillColorWithColor(ctx, _pointColor.CGColor);
                    CGContextFillPath(ctx);
                }
            }
        }
    }
}

- (void)drawDiagonalText:(NSString *)value withContext:(CGContextRef)context atPoint:(CGPoint)point
{
//
// Save the state of the drawing context so we can come
// back to it after we draw the vertical text.
//
    CGContextSaveGState(context);

//
// Move the origin of the view to the location where we'll draw the
// text.
// We do this because rotation will happen with the origin as the
// center.
//
    CGContextTranslateCTM(context, point.x, point.y);

//
// Rotate the view 90 degrees (-1.57 radians) so the next item we
// draw is drawn vertically.
// Apply the rotation transformation.
//
    CGAffineTransform textTransform = CGAffineTransformMakeRotation(-0.80);
    CGContextConcatCTM(context, textTransform);

//
// Move the origin of the view back to the original location so that our
// text will be drawn
// starting at the same point as before, just vertically.
//
    CGContextTranslateCTM(context, -point.x, -point.y);

//
// Draw the text.
//
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont systemFontOfSize:10],
                                NSFontAttributeName,
                                nil ];
    [value drawAtPoint:point withAttributes:attributes];
//
// Restore the view to its state from before we did the move and
// rotation.
//
    CGContextRestoreGState(context);
} 

- (void)drawVerticalText:(NSString *)value withContext:(CGContextRef)context atPoint:(CGPoint)point
{
    //
    // Save the state of the drawing context so we can come
    // back to it after we draw the vertical text.
    //
    CGContextSaveGState(context);
    
    //
    // Move the origin of the view to the location where we'll draw the
    // text.
    // We do this because rotation will happen with the origin as the
    // center.
    //
    CGContextTranslateCTM(context, point.x, point.y);
    
    //
    // Rotate the view 90 degrees (-1.57 radians) so the next item we
    // draw is drawn vertically.
    // Apply the rotation transformation.
    //
    CGAffineTransform textTransform = CGAffineTransformMakeRotation(-1.57);
    CGContextConcatCTM(context, textTransform);
    
    //
    // Move the origin of the view back to the original location so that our
    // text will be drawn
    // starting at the same point as before, just vertically.
    //
    CGContextTranslateCTM(context, -point.x, -point.y);
    
    //
    // Draw the text.
    //
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont systemFontOfSize:12],
                                NSFontAttributeName,
                                nil ];
    [value drawAtPoint:point withAttributes:attributes];
    
    //
    // Restore the view to its state from before we did the move and
    // rotation.
    //
    CGContextRestoreGState(context);
} 


- (void)drawText:(NSString *)message withContext:(CGContextRef)context atPoint:(CGPoint)cgPoint withSize:(float)textSize
{
    // get a font using core text
    CFMutableAttributedStringRef attrStr = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
    CTFontRef font = CTFontCreateWithName(CFSTR("Helvetica"), textSize, NULL);
    CFAttributedStringSetAttribute(attrStr, CFRangeMake(0, CFAttributedStringGetLength(attrStr)), kCTFontAttributeName, font);
    
    CGContextSelectFont(context, "Helvetica", textSize, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetRGBFillColor(context, 0, 0, 0, 1);
    
    CGAffineTransform xform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);
    CGContextSetTextMatrix(context, xform);
    
    CGContextShowTextAtPoint(context, cgPoint.x, cgPoint.y, [message UTF8String], strlen([message UTF8String]));
}

- (void)setSegments:(int)segments
{
    _segments = segments;
    [self setNeedsDisplay];
}

- (void)setShowPoints:(BOOL)showPoints
{
    _showPoints = showPoints;
    [self setNeedsDisplay];
}

- (void)setPointSize:(float)pointSize
{
    _pointSize = pointSize;
    [self setNeedsDisplay];
}

- (void)setPointColor:(UIColor *)pointColor
{
    _pointColor = pointColor;
    [self setNeedsDisplay];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    [self setNeedsDisplay];
}

- (void)setSubTitle:(NSString *)subTitle
{
    _subTitle = subTitle;
    [self setNeedsDisplay];
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    [self setNeedsDisplay];
}

- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    [self setNeedsDisplay];
}

@end
