//
//  CZQLoginAndRegisteModelView.m
//  BuDeJie
//
//  Created by 陈志强 on 16/11/27.
//  Copyright © 2016年 hdu. All rights reserved.
//

#import "CZQLoginAndRegisteModelView.h"

@interface CZQLoginAndRegisteModelView ()

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

@implementation CZQLoginAndRegisteModelView

//快速创建loginView
+ (instancetype)loginView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}

//快速创建registerView
+ (instancetype)registerView{
     return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    //防止图片拉伸 正常状态下
    UIImage *norImage = _loginBtn.currentBackgroundImage;
    norImage = [norImage stretchableImageWithLeftCapWidth:norImage.size.width * 0.5 topCapHeight:norImage.size.height * 0.5];
    [_loginBtn setBackgroundImage:norImage forState:UIControlStateNormal];
    [_registerBtn setBackgroundImage:norImage forState:UIControlStateNormal];
     //防止图片拉伸 高亮状态下
    UIImage *highImage = [_loginBtn backgroundImageForState:UIControlStateHighlighted];
    highImage = [highImage stretchableImageWithLeftCapWidth:highImage.size.width * 0.5 topCapHeight:highImage.size.height * 0.5];
    [_loginBtn setBackgroundImage:highImage forState:UIControlStateHighlighted];
    [_registerBtn setBackgroundImage:highImage forState:UIControlStateHighlighted];
    
    [_loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_registerBtn addTarget:self action:@selector(registerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)loginBtnClick:(UIButton *)loginBtn {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGINBTN_CLICK" object:nil];
}

- (void)registerBtnClick:(UIButton *)registerBtn {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REGISTERBTN_CLICK" object:nil];
}


@end
