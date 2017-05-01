//
//  UIImage+CZQImage.m
//  BuDeJie
//
//  Created by 陈志强 on 16/11/21.
//  Copyright © 2016年 hdu. All rights reserved.
//

#import "UIImage+CZQImage.h"

@implementation UIImage (CZQImage)

//快速创建没有被渲染的图片
+ (UIImage *)imageOriginalWithName:(NSString *)name{
    UIImage *image = [UIImage imageNamed:name];
   return  [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

//裁剪图片拉伸
+ (instancetype)resizableImageWithLocalImageNamed:(NSString *)localImageNamed{
    UIImage *normalImage = [UIImage imageNamed:localImageNamed];
    CGFloat normalImageWith = normalImage.size.width;
    CGFloat normalImagehight = normalImage.size.height;
    return [normalImage stretchableImageWithLeftCapWidth:normalImageWith * 0.5 topCapHeight:normalImagehight * 0.5];
}

@end
