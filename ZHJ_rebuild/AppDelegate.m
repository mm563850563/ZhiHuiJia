//
//  AppDelegate.m
//  ZHJ_rebuild
//
//  Created by sophia on 2017/7/10.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MainTabBarViewController.h"
#import <MLTransition.h>
#import <IQKeyboardManager.h>
#import "SearchNetTool.h"
#import <AFNetworkReachabilityManager.h>

//shareSDK
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯SDK
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微博SDK
#import "WeiboSDK.h"

//paySDK
#import <AlipaySDK/AlipaySDK.h>

//微信SDK
#import "WXApi.h"
#import "WXApiManager.h"

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //***********检查网络*************
//    [SearchNetTool searchNet];

    //1.创建网络监测者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    /*枚举里面四个状态  分别对应 未知 无网络 数据 WiFi
     typedef NS_ENUM(NSInteger, AFNetworkReachabilityStatus) {
     AFNetworkReachabilityStatusUnknown          = -1,      未知
     AFNetworkReachabilityStatusNotReachable     = 0,       无网络
     AFNetworkReachabilityStatusReachableViaWWAN = 1,       蜂窝数据网络
     AFNetworkReachabilityStatusReachableViaWiFi = 2,       WiFi
     };
     */
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"%ld",(long)status);
        //这里是监测到网络改变的block  可以写成switch方便
        //在里面可以随便写事件
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络状态");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"无网络");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"蜂窝数据网");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WiFi网络");
                
                break;
                
            default:
                break;
        }
        
    }] ;
    
    //************全局手势滑动返回*************
    [MLTransition validatePanBackWithMLTransitionGestureRecognizerType:MLTransitionGestureRecognizerTypeScreenEdgePan];
    
    //************ navigationBar相关设置 ************
//    [self settingNavigationBar];
    
    //***************全局键盘自动管理*************
    [self settingIQKeyBoardManager];
    
    //**************支持摇一摇******************
    [self settingShake];
    
    //*********** 注册第三方平台 *************
    [self registerApp];
    
    //************ 第三方登录 *************
    [self registerLoginPlatforms];
    
    //*********** 设置rootVC ***********
    [self settingRootVC];
    
    //****************判断用户是否已登陆***************
    [self presentMainTabVC];
    
    //****************微信支付*****************
    [WXApi registerApp:kWeChatPay_AppID ];
    
    return YES;
}


#pragma mark - <navigationBar相关设置>
-(void)settingNavigationBar
{
    //设置navigationBar颜色
    [[UINavigationBar appearance] setBarTintColor:kColorFromRGB(kThemeYellow)];
    
    //设置返回按钮键
//    UIImage *imgBack = [[UIImage imageNamed:@"back"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [UINavigationBar appearance].backIndicatorTransitionMaskImage = [UIImage imageNamed:@"back"];
    [UINavigationBar appearance].backIndicatorImage = [UIImage imageNamed:@"back"];
}

#pragma mark - <注册第三方平台> 
-(void)registerApp
{
    [WXApi registerApp:@"wxd8b7051c3bd0f932"];
    [WeiboSDK registerApp:@"4152357321"];
}


#pragma mark - <第三方登录平台注册>
-(void)registerLoginPlatforms
{
    [ShareSDK registerActivePlatforms:@[@(SSDKPlatformTypeWechat),
                                        @(SSDKPlatformTypeQQ),
                                        @(SSDKPlatformTypeSinaWeibo)]
                             onImport:^(SSDKPlatformType platformType) {
                                            switch (platformType)
                                            {
                                                case SSDKPlatformTypeWechat:
                                                    [ShareSDKConnector connectWeChat:[WXApi class]];
                                                    break;
                                                case SSDKPlatformTypeQQ:
                                                    [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                                                    break;
                                                case SSDKPlatformTypeSinaWeibo:
                                                    [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                                                    break;
                                                    
                                                default:
                                                    break;
                                            }
                                        }
                      onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                          switch (platformType) {
                              case SSDKPlatformTypeSinaWeibo:
                                  //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                                  [appInfo SSDKSetupSinaWeiboByAppKey:@"4152357321"
                                                            appSecret:@"cd648444ef6c5cc253c33e0fe5751d78"
                                                          redirectUri:@"http://www.havshark.com/api/LoginApi/callback"
                                                             authType:SSDKAuthTypeSSO];
                                  break;
                              case SSDKPlatformTypeWechat:
                                  [appInfo SSDKSetupWeChatByAppId:@"wxd8b7051c3bd0f932"
                                                        appSecret:@"7890cc73b5085d7e14884d297ba4310d"];
                                  break;
                              case SSDKPlatformTypeQQ:
                                  [appInfo SSDKSetupQQByAppId:@"1106054822"
                                                       appKey:@"hfui5JGPp7tyVjrw"
                                                     authType:SSDKAuthTypeBoth];
                                  break;
                                  
                              default:
                                  break;
                          }
                      }];
    
}

#pragma  mark - <mainTabVC页面>
-(void)presentMainTabVC
{
    if (!kUserDefaultObject(kUserInfo)) {
        NSLog(@"--------%@-------",kUserDefaultObject(kUserInfo));
        
    }else{
        NSLog(@"--------%@-------",kUserDefaultObject(kUserInfo));
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MainTabBarViewController *mainTabbarVC = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([MainTabBarViewController class])];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:mainTabbarVC animated:NO completion:nil];
    }
}

#pragma mark - <设置rootVC>
-(void)settingRootVC
{
    LoginViewController *loginVC = [[LoginViewController alloc]initWithNibName:NSStringFromClass([LoginViewController class]) bundle:nil];
    self.window = [[UIWindow alloc]initWithFrame:kScreeFrame];
    self.window.rootViewController = loginVC;
    [self.window makeKeyAndVisible];
    
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    MainTabBarViewController *mainTabbarVC = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([MainTabBarViewController class])];
//    self.window = [[UIWindow alloc]initWithFrame:kScreeFrame];
//    self.window.rootViewController = mainTabbarVC;
//    [self.window makeKeyAndVisible];
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


// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString*, id> *)options
{
//    if ([url.host isEqualToString:@"safepay"]) {
    
    
    
    #pragma mark - <AliPaySDK>
    //跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"result = %@",resultDic);
    }];
    
    
    #pragma mark - <微信支付>
    [WXApi handleOpenURL:url delegate:self];
    return YES;
}

-(void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp*response=(PayResp*)resp;  // 微信终端返回给第三方的关于支付结果的结构体
        switch (response.errCode) {
            case WXSuccess:
            {// 支付成功，向后台发送消息
                NSLog(@"支付成功");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WX_PaySuccess" object:nil];
            }
                break;
            default:{
                NSLog(@"支付失败");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WX_PaySuccess" object:nil];
            }
                break;
        }
    }
}


@end
