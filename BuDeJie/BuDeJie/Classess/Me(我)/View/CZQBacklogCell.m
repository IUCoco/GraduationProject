//
//  CZQBacklogCell.m
//  BuDeJie
//
//  Created by 清风 on 2017/5/13.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import "CZQBacklogCell.h"
#import <Masonry.h>
#import "CZQBacklogItem.h"


@interface CZQBacklogCell ()

@property (nonatomic, weak) UIImageView *myImgView;//左侧图标
@property (nonatomic, weak) UILabel *statusLab;//完成状态label
@property (nonatomic, weak) UILabel *timeUpLab;//日期上label
@property (nonatomic, weak) UILabel *timeDownLab;//日期下label
@property (nonatomic, weak) UILabel *myDetailLab;//具体待办事项
@property (nonatomic, weak) UIView *stripView;//灰色分隔条

@end

@implementation CZQBacklogCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *myImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
//        myImgView.image = [UIImage imageNamed:@"hdate_month"];
        myImgView.layer.masksToBounds = YES;
        myImgView.layer.cornerRadius = 5;
        [self.contentView addSubview:myImgView];
        self.myImgView = myImgView;
        
        UILabel *statusLab = [[UILabel alloc] initWithFrame:CGRectZero];
        statusLab.textColor = [UIColor colorWithRed:139 / 255.0 green:139 / 255.0 blue:139 / 255.0 alpha:1.0];
        statusLab.font = [UIFont boldSystemFontOfSize:16];
//        statusLab.text = @"未完成";
        [self.contentView addSubview:statusLab];
        self.statusLab = statusLab;
        
        UILabel *timeUpLab = [[UILabel alloc] initWithFrame:CGRectZero];
        timeUpLab.textColor = [UIColor colorWithRed:139 / 255.0 green:139 / 255.0 blue:139 / 255.0 alpha:1.0];
        timeUpLab.font = [UIFont boldSystemFontOfSize:12];
//        timeUpLab.text = @"周日";
        [self.contentView addSubview:timeUpLab];
        self.timeUpLab = timeUpLab;
        
        UILabel *timeDownLab = [[UILabel alloc] initWithFrame:CGRectZero];
        timeDownLab.textColor = [UIColor colorWithRed:139 / 255.0 green:139 / 255.0 blue:139 / 255.0 alpha:1.0];
        timeDownLab.font = [UIFont boldSystemFontOfSize:10];
//        timeDownLab.text = @"05/14";
        [self.contentView addSubview:timeDownLab];
        self.timeDownLab = timeDownLab;
        
        
        UILabel *myDetailLab = [[UILabel alloc] initWithFrame:CGRectZero];
        myDetailLab.textColor = [UIColor colorWithRed:165 / 255.0 green:165 / 255.0 blue:165 / 255.0 alpha:1.0];
        myDetailLab.font = [UIFont boldSystemFontOfSize:12];
        myDetailLab.numberOfLines = 0;
//        myDetailLab.text = @"卖给乌索普一枚炸弹,卖给索隆一把刀";
        [self.contentView addSubview:myDetailLab];
        self.myDetailLab = myDetailLab;
        
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
    
    [self.statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.myImgView.mas_right).offset(13);
        make.top.equalTo(self.myImgView.mas_top).offset(3);
        make.height.mas_equalTo(15);
    }];
    
    [self.timeUpLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.top.equalTo(self.myImgView.mas_top).offset(3);
        make.height.mas_equalTo(10);
    }];
    
    [self.timeDownLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.top.equalTo(self.timeUpLab.mas_bottom).offset(3);
        make.height.mas_equalTo(10);
    }];
    
    [self.myDetailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.myImgView.mas_right).offset(13);
        make.right.equalTo(self.contentView.mas_right).offset(- 28);
        make.top.equalTo(self.statusLab.mas_bottom).offset(3);
        make.height.mas_equalTo(40);
    }];
    
    [self.stripView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.right.equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(1);
    }];
    
}

- (void)setItem:(CZQBacklogItem *)item {
    _item = item;
    self.myImgView.image = [UIImage imageNamed:item.imageStr];
    self.statusLab.text = item.statusStr;
    self.timeUpLab.text = item.timeStrUp;
    self.timeDownLab.text = item.timeStrDown;
    self.myDetailLab.text = item.detailStr;
}



@end
