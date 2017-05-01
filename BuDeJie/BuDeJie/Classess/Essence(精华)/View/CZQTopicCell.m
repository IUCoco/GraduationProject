//
//  CZQTopicCell.m
//  BuDeJie
//
//  Created by 清风 on 2017/2/1.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import "CZQTopicCell.h"
#import "CZQTopic.h"
#import "UIImage+CZQImage.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CZQTopicVideoView.h"
#import "CZQTopicVoiceView.h"
#import "CZQTopicPictureView.h"

@interface CZQTopicCell ()

// 控件的命名 -> 功能 + 控件类型
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *passtimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *text_label;
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
@property (weak, nonatomic) IBOutlet UIButton *repostButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIView *topCmtView;//最热评论模块整体用来判断是否隐藏
@property (weak, nonatomic) IBOutlet UILabel *topCmtLable;//最热评论内容

//中间控件
@property(nonatomic, weak) CZQTopicPictureView *pictureView;
@property(nonatomic, weak) CZQTopicVoiceView *voiceView;
@property(nonatomic, weak) CZQTopicVideoView *videoView;

@end

@implementation CZQTopicCell

- (CZQTopicPictureView *)pictureView{
    if (!_pictureView) {
        CZQTopicPictureView *pictureView = [CZQTopicPictureView czq_viewFromXib];
        [self.contentView addSubview:pictureView];
        _pictureView = pictureView;
    }
    return _pictureView;
}

- (CZQTopicVoiceView *)voiceView{
    if (!_voiceView) {
        CZQTopicVoiceView *voiceView = [CZQTopicVoiceView czq_viewFromXib];
        [self.contentView addSubview:voiceView];
        _voiceView = voiceView;
    }
    return _voiceView;
}

- (CZQTopicVideoView *)videoView{
    if (!_videoView) {
        CZQTopicVideoView *videoView = [CZQTopicVideoView czq_viewFromXib];
        [self.contentView addSubview:videoView];
        _videoView = videoView;
    }
    return _videoView;
}

//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
//    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        //增加顶部控件，并设置约束
//        
//        //增加底部控件，并设置约束
//        
//    }
//    return self;
//}

- (void)awakeFromNib{
    [super awakeFromNib];
    //设置cell的背景图片 已经拉伸处理过
    UIImage *newImage = [UIImage resizableImageWithLocalImageNamed:@"mainCellBackground"];
    self.backgroundView = [[UIImageView alloc] initWithImage:newImage];
    //设置圆角
    self.profileImageView.layer.cornerRadius = 17.5;
    self.profileImageView.layer.masksToBounds = YES;
}

- (void)setTopic:(CZQTopic *)topic{
    _topic = topic;
    //设置顶部和底部的具体数据
    self.nameLabel.text = topic.name;
    self.passtimeLabel.text = topic.passtime;
    self.text_label.text = topic.text;
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:topic.profile_image] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"] options:0 completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        //--------->避免图片加载不出来的时候不显示
        if (!image) return;
    }];
    [self.dingButton setTitle:[NSString stringWithFormat:@"%ld", topic.ding] forState:UIControlStateNormal];
    [self.caiButton setTitle:[NSString stringWithFormat:@"%ld", topic.cai] forState:UIControlStateNormal];
    [self.repostButton setTitle:[NSString stringWithFormat:@"%ld", topic.repost] forState:UIControlStateNormal];
    [self.commentButton setTitle:[NSString stringWithFormat:@"%ld", topic.comment] forState:UIControlStateNormal];
    //设置最热评论
    if (topic.top_cmt.count == 0) {
        self.topCmtView.hidden = YES;
    }else{
        self.topCmtView.hidden = NO;
        NSDictionary *topCmtDic = topic.top_cmt.firstObject;
        NSString *content = topCmtDic[@"content"];
        if (content.length == 0) {//语音评论
            content = @"[语音评论]";
        }
        NSString *userName = topCmtDic[@"user"][@"username"];
        self.topCmtLable.text = [NSString stringWithFormat:@"%@：%@", userName, content];
    }
    
    //中间内容
    if (topic.type == CZQTopicTypePicture) {//图片
//        [self.contentView addSubview:[CZQTopicPictureView czq_viewFromXib]];
        self.pictureView.hidden = NO;
        self.voiceView.hidden = YES;
        self.videoView.hidden = YES;
        self.pictureView.topic = topic;
    }else if (topic.type == CZQTopicTypeWord){//文字
        //循环引用问题
        self.pictureView.hidden = YES;
        self.videoView.hidden = YES;
        self.voiceView.hidden = YES;
    }else if (topic.type == CZQTopicTypeVoice){//音频
//        [self.contentView addSubview:[CZQTopicVoiceView czq_viewFromXib]];
        self.voiceView.hidden = NO;
        self.pictureView.hidden = YES;
        self.videoView.hidden = YES;
        self.voiceView.topic = topic;
    }else if (topic.type == CZQTopicTypeVideo){//视频
//        [self.contentView addSubview:[CZQTopicVideoView czq_viewFromXib]];
        self.videoView.hidden = NO;
        self.pictureView.hidden = YES;
        self.voiceView.hidden = YES;
        self.videoView.topic = topic;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.topic.type == CZQTopicTypePicture) {//图片
        self.pictureView.frame = self.topic.middleFrame;
    }else if (self.topic.type == CZQTopicTypeVoice){//音频
        self.voiceView.frame = self.topic.middleFrame;
    }else if (self.topic.type == CZQTopicTypeVideo){//视频
        self.videoView.frame = self.topic.middleFrame;
    }

}

- (void)setFrame:(CGRect)frame{
    frame.size.height -= 10;
    [super setFrame:frame];
}

@end
