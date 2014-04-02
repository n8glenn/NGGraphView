//
//  NGDataPoint.m
//  Nate Glenn
//
//  Created by Nate Glenn on 4/14/12.
//  Copyright (c) 2012 Nate Glenn. All rights reserved.
//

#import "NGDataPoint.h"

@implementation NGDataPoint

@synthesize label=_label;
@synthesize count=_count;

+ (id)withLabel:(NSString *)itemLabel andCount:(int)itemCount;
{
    NGDataPoint *dp = [[NGDataPoint alloc] init];
    [dp setLabel:itemLabel];
    [dp setCount:itemCount];
    return dp;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Label = %@, Count = %d", _label, _count];
}

@end
