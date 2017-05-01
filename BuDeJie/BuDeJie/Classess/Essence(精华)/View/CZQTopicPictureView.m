//
//  CZQTopicPictureView.m
//  BuDeJie
//
//  Created by 清风 on 2017/2/2.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import "CZQTopicPictureView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CZQTopic.h"
#import <AFNetworking/AFNetworking.h>

@interface CZQTopicPictureView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *placeholderView;
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
@property (weak, nonatomic) IBOutlet UIButton *seeBigPictureButton;

@end

@implementation CZQTopicPictureView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
}

- (void)setTopic:(CZQTopic *)topic{
    _topic = topic;
    //开始显示占位图片
    self.placeholderView.hidden = NO;//只有图片不存在时候才显示，不能根据网络来判断
    //根据网络状况加载不同质量的图片
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //查看沙盒里面是否有原始高质量图片
    //SDWebImage----->一个URL（key）对应一个图片
    UIImage *originalImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:topic.image1];//沙盒会先查看内存再查看沙盒
    if (originalImage) {//以前已经下载过了
        self.imageView.image = originalImage;
        self.placeholderView.hidden = YES;
    }else{//以前没有下载过
        //根据网络情况判断下载哪种质量图片
        if (manager.isReachableViaWWAN) {//移动蜂窝网络
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.image2] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (!image) return ;
                self.placeholderView.hidden = YES;
                //处理图片显示
//                [self dealLongImage];
            }];
        }else if (manager.isReachableViaWiFi){//WiFi
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.image1] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (!image) return ;
                self.placeholderView.hidden = YES;
//                [self dealLongImage];
            }];
        }
    }
    //处理GIF提示图标
    self.gifView.hidden = !topic.is_gif;
    //处理显示大图按钮
    if (topic.isLongImage) {
        self.seeBigPictureButton.hidden = NO;
        self.imageView.contentMode = UIViewContentModeTop;
        self.imageView.clipsToBounds = YES;
    }else{
        self.seeBigPictureButton.hidden = YES;
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        self.imageView.clipsToBounds = NO;
    }

}


- (void)dealLongImage{
    //处理图片显示
    if (self.topic.isLongImage) {
        CGFloat imageW = self.topic.middleFrame.size.width;
        CGFloat imageH = self.topic.height * imageW / self.topic.width;
        UIGraphicsBeginImageContext(CGSizeMake(imageW, imageH));
        [self.imageView.image drawInRect:CGRectMake(0, 0, imageW, imageH)];
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
}

@end
