//
//  AppDelegate.m
//  BuDeJie
//
//  Created by 陈志强 on 16/11/21.
//  Copyright © 2016年 hdu. All rights reserved.
//

#import "AppDelegate.h"
//#import "CZQTabBarController.h"
#import "CZQADViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <UserNotifications/UserNotifications.h>

#define LOCAL_PUSH_TEXT  @[@"快来联系您的新客户吧！"]

//遵守UITabBarControllerDelegate监听tabBar的连续点击
@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //1.创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //2.设置窗口根控制器
//    CZQTabBarController *winRootVC = [[CZQTabBarController alloc] init];
//    self.window.rootViewController = winRootVC;
    //2.设置窗口的根控制器为广告控制器
    CZQADViewController *adVC = [[CZQADViewController alloc] init];
    //init底层调用 initWithNib
    self.window.rootViewController = adVC;
    //3.设置为application的主窗口并且显示
    [self.window makeKeyAndVisible];
    
    //监控网络状态
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    //本地通知
    //注册通知
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            NSLog(@"request authorization successed!");
        }
    }];
    //之前注册推送服务，用户点击了同意还是不同意，以及用户之后又做了怎样的更改我们都无从得知，现在 apple 开放了这个 API，我们可以直接获取到用户的设定信息了。
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        NSLog(@"%@",settings);
    }];
    
    //删除上一次通知
    [self deleteNotification];
    
    [self regiterLocalNotification];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - handleLocalNotification

- (void)regiterLocalNotification{
    
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"销售助手最新通知";
    content.subtitle = @"有新的任务快来完成";
    content.body = LOCAL_PUSH_TEXT[0];
    content.badge = @1;
    
    //重复提醒，时间间隔要大于60s
    UNTimeIntervalNotificationTrigger *trigger1 = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:70 repeats:YES];
    NSString *requertIdentifier = @"RequestIdentifier";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requertIdentifier content:content trigger:trigger1];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"Error:%@",error);
    }];
    
}

//只有当前处于前台才会走，加上返回方法，使在前台显示信息
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
    NSLog(@"执行willPresentNotificaiton");
    completionHandler(UNNotificationPresentationOptionBadge|
                      UNNotificationPresentationOptionSound|
                      UNNotificationPresentationOptionAlert);
}

//删除本地通知
- (void)deleteNotification {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}



@end
