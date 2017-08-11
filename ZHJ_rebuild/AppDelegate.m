//
//  AppDelegate.m
//  ZHJ_rebuild
//
//  Created by sophia on 2017/7/10.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginView.h"
#import "MainTabBarViewController.h"
#import <MLTransition.h>
#import <IQKeyboardManager.h>
#import <AFNetworkReachabilityManager.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //检查网络
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            {
                //未知网络
                NSLog(@"未知网络");
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
                //无法联网
                NSLog(@"请检查网络");
            }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                //手机自带网络
                NSLog(@"当前使用的是2g/3g/4g网络");
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                //WIFI
                NSLog(@"当前在WIFI网络下");
            }
        }
    }];
    [manager startMonitoring];
    
    
    //全局手势滑动返回
    [MLTransition validatePanBackWithMLTransitionGestureRecognizerType:MLTransitionGestureRecognizerTypeScreenEdgePan];
    
    //全局键盘自动管理
    [self settingIQKeyBoardManager];
    //支持摇一摇
    [self settingShake];
    
    [self settingMainTabbarVC];
    [self presentLogionVC];
    
    return YES;
}

#pragma  mark - <登录页面>
-(void)presentLogionVC
{
    if (!kUserDefaultObject(kUserInfo)) {
        NSLog(@"--------%@-------",kUserDefaultObject(kUserInfo));
        LoginView *loginView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([LoginView class]) owner:nil options:nil].lastObject;
        [self.window addSubview:loginView];
        [self.window bringSubviewToFront:loginView];
    }else{
        NSLog(@"--------%@-------",kUserDefaultObject(kUserInfo));
    }
}

#pragma mark - <设置mainTabbar>
-(void)settingMainTabbarVC
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainTabBarViewController *mainTabbarVC = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([MainTabBarViewController class])];
    self.window = [[UIWindow alloc]initWithFrame:kScreeFrame];
    self.window.rootViewController = mainTabbarVC;
    [self.window makeKeyAndVisible];
}

#pragma mark - <支持摇一摇功能>
-(void)settingShake
{
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
}


#pragma mark - <IQKeyBoardManager全局键盘管理>
-(void)settingIQKeyBoardManager
{
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    
    keyboardManager.enable = YES; // 控制整个功能是否启用
    
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
    
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    
    keyboardManager.enableAutoToolbar = YES; // 控制是否显示键盘上的工具条
    
    keyboardManager.shouldShowTextFieldPlaceholder = YES; // 是否显示占位文字
    
    keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:15]; // 设置占位文字的字体
    
    keyboardManager.keyboardDistanceFromTextField = 10.0f; // 输入框距离键盘的距离
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
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
