//
//  CZQTopicVoiceView.m
//  BuDeJie
//
//  Created by 清风 on 2017/2/2.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import "CZQTopicVoiceView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CZQTopic.h"
#import <AFNetworking/AFNetworking.h>

@interface CZQTopicVoiceView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *voicetimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *placeholderImageView;//占位图片

@end

@implementation CZQTopicVoiceView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
}

- (void)setTopic:(CZQTopic *)topic{
    _topic = topic;
    //开始显示占位图片
    self.placeholderImageView.hidden = NO;//只有图片不存在时候才显示，不能根据网络来判断
    //根据网络状况加载不同质量的图片
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //查看沙盒里面是否有原始高质量图片
    //SDWebImage----->一个URL（key）对应一个图片
    UIImage *originalImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:topic.image1];//沙盒会先查看内存再查看沙盒
    if (originalImage) {//以前已经下载过了
        self.imageView.image = originalImage;
        self.placeholderImageView.hidden = YES;
    }else{//以前没有下载过
        //根据网络情况判断下载哪种质量图片
        if (manager.isReachableViaWWAN) {//移动蜂窝网络
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.image2] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (!image) return ;
                self.placeholderImageView.hidden = YES;
            }];
        }else if (manager.isReachableViaWiFi){//WiFi
          [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.image1] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
              if (!image) return ;
              self.placeholderImageView.hidden = YES;
          }];
        }
    }
    if (topic.playcount >= 10000) {
        self.playcountLabel.text = [NSString stringWithFormat:@"%.1f万", topic.playcount / 10000.0 ];
    }else{
       self.playcountLabel.text = [NSString stringWithFormat:@"%ld", topic.playcount];
    }
    self.voicetimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", topic.voicetime / 60, topic.voicetime % 60];
}

@end
