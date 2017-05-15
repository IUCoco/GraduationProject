//
//  IDInfoViewController.m
//  IDCardRecognition
//
//  Created by zhongfeng1 on 2017/2/21.
//  Copyright © 2017年 李中峰. All rights reserved.
//

#import "IDInfoViewController.h"
#import "IDInfo.h"
#import "AVCaptureViewController.h"
#import <SVProgressHUD.h>

@interface IDInfoViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *IDImageView;
@property (strong, nonatomic) IBOutlet UILabel *IDNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;

@end

@implementation IDInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"身份证信息";
    
    self.IDImageView.layer.cornerRadius = 8;
    self.IDImageView.layer.masksToBounds = YES;
    
    self.IDNumLabel.text = _IDInfo.num;
    self.addressLabel.text = _IDInfo.address;
    self.nameLabel.text = _IDInfo.name;
    self.sexLabel.text = _IDInfo.gender;//性别
    self.IDImageView.image = _IDImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 错误，重新拍摄
- (IBAction)shootAgain:(UIButton *)sender {    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 正确，下一步
- (IBAction)nextStep:(UIButton *)sender {
    NSLog(@"经用户核对，身份证号码正确，那就进行下一步，比如身份证图像或号码经加密后，传递给后台");
    //新的模型
    NSDictionary *NewItemDit = @{
                                 @"imageStr" : @"customer.png",
                                 @"nameStr" : self.nameLabel.text,
                                 @"locationStr" : self.addressLabel.text,
                                 @"sexStr" : self.sexLabel.text,
                                 @"idcardNumStr" : self.IDNumLabel.text
                                 };
    //获取bundle中的plist
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"FriendThrends.plist" ofType:nil];
    NSMutableArray *bundelArrM = [NSMutableArray arrayWithContentsOfFile:dataPath];
    
    [bundelArrM insertObject:NewItemDit atIndex:0];
    
    NSString *docPath =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [docPath stringByAppendingPathComponent:@"FriendThrends.plist"];
    
    BOOL ww = [bundelArrM writeToFile:filePath atomically:YES];
    
    NSArray *shaheArrM = [NSArray arrayWithContentsOfFile:filePath];
    
    //发布计划发布成功通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ADD_FRIEND_THRENDS_SUCCESS" object:nil];
    
    //提示框提示
    [SVProgressHUD showSuccessWithStatus:@"添加客户成功"];
    
    //退出
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    });
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationAVCaptureViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
