//
//  XMGTagButton.m
//  3期-百思不得姐
//
//  Created by xiaomage on 15/9/11.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGTagButton.h"

@implementation XMGTagButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = XMGTagBgColor;
        [self setImage:[UIImage imageNamed:@"chose_tag_close_icon"] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    
    // 自动计算
    [self sizeToFit];
    
    // 微调
    self.height = XMGTagH;
    self.width += 3 * XMGCommonSmallMargin;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.x = XMGCommonSmallMargin;
    
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + XMGCommonSmallMargin;
}

@end
