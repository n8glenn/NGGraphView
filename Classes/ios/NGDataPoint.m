//
//  NGDataPoint.m
//  Nate Glenn
//
//  Created by Nate Glenn on 4/14/12.
//  Copyright (c) 2012 Nate Glenn. All rights reserved.
//

#import "NGDataPoint.h"
#import <Foundation/Foundation.h>

@implementation NGDataPoint

@synthesize label=_label;
@synthesize itemCount=_itemCount;

+ (id)withLabel:(NSString *)itemLabel andCount:(int)itemCount;
{
    NGDataPoint *dp = [[NGDataPoint alloc] init];
    [dp setLabel:itemLabel];
    [dp setItemCount:itemCount];
    return dp;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Label = %@, Count = %d", _label, _itemCount];
}

@end
