//
//  CZQVideoCell.m
//  BuDeJie
//
//  Created by 清风 on 2017/2/1.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import "CZQVideoCell.h"
#import "CZQVideoItem.h"
#import <Masonry.h>

@interface CZQVideoCell ()

@property (nonatomic, weak) UIImageView *myImgView;//左侧头像
@property (nonatomic, weak) UILabel *timeLab;//客户姓名label
@property (nonatomic, weak) UILabel *detailLab;//客户住址label
@property (nonatomic, weak) UIView *stripView;//灰色分隔条

@end

@implementation CZQVideoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *myImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        myImgView.image = [UIImage imageNamed:@"capa"];
        myImgView.layer.masksToBounds = YES;
        myImgView.layer.cornerRadius = 5;
        [self.contentView addSubview:myImgView];
        self.myImgView = myImgView;
        
        UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectZero];
        timeLab.textColor = [UIColor colorWithRed:139 / 255.0 green:139 / 255.0 blue:139 / 255.0 alpha:1.0];
        timeLab.font = [UIFont boldSystemFontOfSize:12];
        timeLab.text = @"2017-05-14";
        [self.contentView addSubview:timeLab];
        self.timeLab = timeLab;
        
        UILabel *detailLab = [[UILabel alloc] initWithFrame:CGRectZero];
        detailLab.textColor = [UIColor colorWithRed:165 / 255.0 green:165 / 255.0 blue:165 / 255.0 alpha:1.0];
        detailLab.font = [UIFont boldSystemFontOfSize:12];
        detailLab.numberOfLines = 0;
        detailLab.text = @"本周写完毕业设计+论文部分";
        [self.contentView addSubview:detailLab];
        self.detailLab = detailLab;
        
        UIView *stripView = [[UIView alloc] initWithFrame:CGRectZero];
        RGB(246, 246, 246, stripView);
        [self.contentView addSubview:stripView];
        self.stripView = stripView;
        
        [self layoutUI];

        
    }
    return self;
}

- (void)layoutUI {
    [self.myImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(12);
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(- 12);
        make.width.mas_equalTo(65);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.top.equalTo(self.myImgView.mas_top).offset(3);
        make.height.mas_equalTo(10);
    }];
    
    [self.detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.myImgView.mas_right).offset(13);
        make.right.equalTo(self.contentView.mas_right).offset(- 28);
        make.top.equalTo(self.timeLab.mas_bottom).offset(3);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
    }];
    
    [self.stripView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.right.equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    
}

- (void)setItem:(CZQVideoItem *)item {
    self.myImgView.image = [UIImage imageNamed:item.imageStr];//左侧头像
    self.timeLab.text = item.timeStr;//客户姓名label
    self.detailLab.text = item.detailStr;//客户住址label
}



@end
