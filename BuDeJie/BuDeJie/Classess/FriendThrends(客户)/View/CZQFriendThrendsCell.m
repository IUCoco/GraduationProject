//
//  CZQFriendThrendsCell.m
//  BuDeJie
//
//  Created by 清风 on 2017/5/13.
//  Copyright © 2017年 hdu. All rights reserved.
//

#import "CZQFriendThrendsCell.h"
#import "CZQFriendThrendsItem.h"
#import <Masonry.h>

@interface CZQFriendThrendsCell ()

@property (nonatomic, weak) UIImageView *myImgView;//左侧头像
@property (nonatomic, weak) UILabel *nameLab;//客户姓名label
@property (nonatomic, weak) UILabel *locationLab;//客户住址label
@property (nonatomic, weak) UILabel *sexLab;//客户性别label
@property (nonatomic, weak) UILabel *idcardNumLab;//身份证号码
@property (nonatomic, weak) UIView *stripView;//灰色分隔条

@end

@implementation CZQFriendThrendsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *myImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        myImgView.image = [UIImage imageNamed:@"customer"];
        myImgView.layer.masksToBounds = YES;
        myImgView.layer.cornerRadius = 5;
        [self.contentView addSubview:myImgView];
        self.myImgView = myImgView;
        
        UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectZero];
        nameLab.textColor = [UIColor colorWithRed:139 / 255.0 green:139 / 255.0 blue:139 / 255.0 alpha:1.0];
        nameLab.font = [UIFont boldSystemFontOfSize:16];
        nameLab.text = @"妮可罗宾";
        [self.contentView addSubview:nameLab];
        self.nameLab = nameLab;
        
        UILabel *sexLab = [[UILabel alloc] initWithFrame:CGRectZero];
        sexLab.textColor = [UIColor colorWithRed:139 / 255.0 green:139 / 255.0 blue:139 / 255.0 alpha:1.0];
        sexLab.font = [UIFont boldSystemFontOfSize:12];
        sexLab.text = @"性别:女";
        [self.contentView addSubview:sexLab];
        self.sexLab = sexLab;
        
        UILabel *locationLab = [[UILabel alloc] initWithFrame:CGRectZero];
        locationLab.textColor = [UIColor colorWithRed:165 / 255.0 green:165 / 255.0 blue:165 / 255.0 alpha:1.0];
        locationLab.font = [UIFont boldSystemFontOfSize:12];
        locationLab.numberOfLines = 0;
        locationLab.text = @"杭州电子科技大学生活区二栋610";
        [self.contentView addSubview:locationLab];
        self.locationLab = locationLab;
        
        UILabel *idcardNumLab = [[UILabel alloc] initWithFrame:CGRectZero];
        idcardNumLab.textColor = [UIColor colorWithRed:165 / 255.0 green:165 / 255.0 blue:165 / 255.0 alpha:1.0];
        idcardNumLab.font = [UIFont boldSystemFontOfSize:12];
        idcardNumLab.numberOfLines = 0;
        idcardNumLab.text = @"21112119930421201X";
        [self.contentView addSubview:idcardNumLab];
        self.idcardNumLab = idcardNumLab;
        
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
    
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.myImgView.mas_right).offset(13);
        make.top.equalTo(self.myImgView.mas_top).offset(3);
        make.height.mas_equalTo(15);
    }];
    
    [self.sexLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.top.equalTo(self.myImgView.mas_top).offset(3);
        make.height.mas_equalTo(10);
    }];
    
    [self.locationLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.myImgView.mas_right).offset(13);
        make.right.equalTo(self.contentView.mas_right).offset(- 28);
        make.top.equalTo(self.nameLab.mas_bottom).offset(3);
        make.height.mas_equalTo(20);
    }];
    
    [self.idcardNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.myImgView.mas_right).offset(13);
        make.right.equalTo(self.contentView.mas_right).offset(- 28);
        make.top.equalTo(self.locationLab.mas_bottom).offset(3);
        make.height.mas_equalTo(20);
    }];
    
    [self.stripView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.right.equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(1);
    }];
    
}

- (void)setItem:(CZQFriendThrendsItem *)item {
    self.myImgView.image = [UIImage imageNamed:item.imageStr];//左侧头像
    self.nameLab.text = item.nameStr;//客户姓名label
    self.locationLab.text = item.locationStr;//客户住址label
    self.sexLab.text = item.sexStr;//客户性别label
    self.idcardNumLab.text = item.idcardNumStr;//身份证号码
}

@end
