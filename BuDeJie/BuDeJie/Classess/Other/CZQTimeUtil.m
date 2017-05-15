//
//  CZQTimeUtil.m
//  BuDeJie
//
//  Created by 清风 on 2017/5/15.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import "CZQTimeUtil.h"

@implementation CZQTimeUtil

+ (NSString *)timeWithYMD {
    NSDate *date = [NSDate date];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    return  [fmt stringFromDate:date];
}

+ (NSString *)timeWithHM {
    NSDate *date = [NSDate date];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"HH:mm";
    
    return  [fmt stringFromDate:date];
}

@end
