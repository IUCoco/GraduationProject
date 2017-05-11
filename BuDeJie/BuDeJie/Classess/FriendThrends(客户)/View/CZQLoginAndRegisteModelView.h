//
//  CZQLoginAndRegisteModelView.h
//  BuDeJie
//
//  Created by 陈志强 on 16/11/27.
//  Copyright © 2016年 hdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CZQLoginTextF;

@interface CZQLoginAndRegisteModelView : UIView

//快速创建loginView
+ (instancetype)loginView;
//快速创建registerView
+ (instancetype)registerView;

@property (weak, nonatomic) IBOutlet CZQLoginTextF *loginPhoneNum;

@property (weak, nonatomic) IBOutlet CZQLoginTextF *loginPwd;

@property (weak, nonatomic) IBOutlet CZQLoginTextF *registPhoneNum;

@property (weak, nonatomic) IBOutlet CZQLoginTextF *registPwd;

@end
