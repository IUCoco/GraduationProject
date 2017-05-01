//
//  CZQTopic.m
//  BuDeJie
//
//  Created by 清风 on 2017/1/29.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import "CZQTopic.h"

@implementation CZQTopic

- (CGFloat)cellHeight{
    //如果已经计算过返回
    if(_cellHeight) return _cellHeight;
//文字的Y值
    _cellHeight += 55;
//文字的高度
    CGSize textMaxSize = CGSizeMake(CZQScreenWith - 20, MAXFLOAT);
// cellHeight += [topic.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:textMaxSize].height + 10;
    NSMutableDictionary *attributesDic = [NSMutableDictionary dictionary];
    attributesDic[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    _cellHeight += [self.text boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDic context:nil].size.height + 10;
    //中间的内容
    if (self.type != CZQTopicTypeWord) {
        CGFloat middleWidth = textMaxSize.width;
        CGFloat middleHeight = middleWidth * self.height / self.width;
        //判断是否为大图
        if (middleHeight > CZQScreenHight) {
            self.LongImage = YES;
            middleHeight = 200;
        }
        CGFloat middleX = 10;
        CGFloat middleY = _cellHeight;//上一个cellHeight
        self.middleFrame = CGRectMake(middleX, middleY, middleWidth, middleHeight);
        _cellHeight += middleHeight + 10;
    }
    //最热评论
    if (self.top_cmt.count) {
        //标题
        _cellHeight += 18 + 5;
        //内容
        NSDictionary *topCmtDic = self.top_cmt.firstObject;
        NSString *content = topCmtDic[@"content"];
        if (content.length == 0) {//语音评论
            content = @"[语音评论]";
        }
        NSString *userName = topCmtDic[@"user"][@"username"];
        NSString *cmtStr = [NSString stringWithFormat:@"%@:%@", userName, content];
       _cellHeight += [cmtStr boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDic context:nil].size.height + 10;  
    }
//工具条
    _cellHeight += 35 + 10;
    
    return _cellHeight;
}

@end
