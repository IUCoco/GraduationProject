//
//  CZQBacklogItem.h
//  BuDeJie
//
//  Created by 清风 on 2017/5/13.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CZQBacklogItem : NSObject

@property (nonatomic, strong) NSString *imageStr;//左侧图像
@property (nonatomic, strong) NSString *statusStr;//完成状态
@property (nonatomic, strong) NSString *timeStrUp;//时间label上
@property (nonatomic, strong) NSString *timeStrDown;//时间label上
@property (nonatomic, strong) NSString *detailStr;//时间label上

@end
