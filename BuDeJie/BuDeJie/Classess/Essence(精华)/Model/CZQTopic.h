//
//  CZQTopic.h
//  BuDeJie
//
//  Created by 清风 on 2017/1/29.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CZQTopicType){
    CZQTopicTypeAll = 1,//1为全部
    CZQTopicTypePicture = 10,//10为图片
    CZQTopicTypeWord = 29,//29为段子
    CZQTopicTypeVoice = 31,//31为音频
    CZQTopicTypeVideo = 41//41为视频
};

@interface CZQTopic : NSObject
//用户的名字
@property(nonatomic, copy) NSString *name;
//用户的头像
@property(nonatomic, copy) NSString *profile_image;
//帖子的文字内容
@property(nonatomic, copy) NSString *text;
//帖子审核通过的时间
@property(nonatomic, copy) NSString *passtime;

//顶数量
@property(nonatomic, assign) NSInteger ding;
//踩数量
@property(nonatomic, assign) NSInteger cai;
//转发分享数量
@property(nonatomic, assign) NSInteger repost;
//评论数量
@property(nonatomic, assign) NSInteger comment;
//帖子的类型
@property(nonatomic, assign) NSInteger type;//1为全部，10为图片，29为段子，31为音频，41为视频，默认为1
//-------->自己添加属性--> 对应每个模型的cell高度，为了缓存cell高度
@property (nonatomic, assign) CGFloat cellHeight;

//最热评论
@property(nonatomic, strong) NSArray *top_cmt;
//中间内容高度视频或图片类型帖子的宽度
@property(nonatomic, assign) NSInteger height;
//中间内容高度视频或图片类型帖子的宽度
@property(nonatomic, assign) NSInteger width;
//------>自己增加的属性中间控件的frame
@property(nonatomic, assign) CGRect middleFrame;

/** 小图 */
@property (nonatomic, copy) NSString *image0;
/** 中图 */
@property (nonatomic, copy) NSString *image2;
/** 大图 */
@property (nonatomic, copy) NSString *image1;
/** 是否为动图 */
@property (nonatomic, assign) BOOL is_gif;
/** ------>自己增加的属性是否为动图 */
@property (nonatomic, assign, getter=isLongImage) BOOL LongImage;

/** 音频时长 */
@property (nonatomic, assign) NSInteger voicetime;
/** 视频时长 */
@property (nonatomic, assign) NSInteger videotime;
/** 音频\视频的播放次数 */
@property (nonatomic, assign) NSInteger playcount;

@end
