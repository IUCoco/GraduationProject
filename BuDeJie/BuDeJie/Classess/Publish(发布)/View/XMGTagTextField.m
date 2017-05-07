//
//  XMGTagTextField.m
//  3期-百思不得姐
//
//  Created by xiaomage on 15/9/11.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGTagTextField.h"

@implementation XMGTagTextField

/**
 * 监听键盘内部的删除键点击
 */
- (void)deleteBackward
{
    // 执行需要做的操作
    !self.deleteBackwardOperation ? : self.deleteBackwardOperation();
    
    [super deleteBackward];
}

@end
