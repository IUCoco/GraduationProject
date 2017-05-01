//
//  CZQWoldCell.m
//  BuDeJie
//
//  Created by 清风 on 2017/2/1.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import "CZQWoldCell.h"

@implementation CZQWoldCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //增加中间文字控件控件，并设置约束
         [self.contentView setBackgroundColor:[UIColor brownColor]];
        
        
    }
    return self;
}

- (void)setTopic:(CZQTopic *)topic{
    [super setTopic:topic];
    //设置中间文字控件的具体数据
    
}

@end
