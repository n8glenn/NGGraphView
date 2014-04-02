//
//  NGDataPoint.h
//  Nate Glenn
//
//  Created by Nate Glenn on 4/14/12.
//  Copyright (c) 2012 Nate Glenn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGDataPoint : NSObject
{
    NSString *_label;
    int _count;
}

@property (nonatomic, retain) NSString *label;
@property (nonatomic) int count;

+ (id)withLabel:(NSString *)itemLabel andCount:(int)itemCount;

@end
