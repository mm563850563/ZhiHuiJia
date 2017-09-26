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
#import <UserNotifications/UserNotifications.h>

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

//IM SDK
#import <Hyphenate/Hyphenate.h>

@interface AppDelegate ()<WXApiDelegate,EMChatManagerDelegate>

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
    [WXApi registerApp:kWeChatAppID];
    
    //**************注册环信SDK***************
    [self registerIM];
    
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

#pragma mark - <注册环信SDK>
-(void)registerIM
{
    EMOptions *options = [EMOptions optionsWithAppkey:kEMAppKey];
    options.apnsCertName = kEMApnsCert;
    [[EMClient sharedClient]initializeSDKWithOptions:options];
    
    //注册离线推送
    UIApplication *application = [UIApplication sharedApplication];
    //ios10注册
    if (NSClassFromString(@"UNUserNotificationCenter")) {
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                [application registerForRemoteNotifications];
            }
        }];
    }
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType notiationTypes = UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notiationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
    }else{
        UIRemoteNotificationType notiticationType = UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound;
        //*************************************
        [application registerForRemoteNotificationTypes:notiticationType];
    }
    
    //登陆环信
    if (kUserDefaultObject(kUserInfo) && kUserDefaultObject(kUserPassword)) {
        [[EMClient sharedClient]loginWithUsername:kUserDefaultObject(kUserInfo) password:kUserDefaultObject(kUserPassword) completion:^(NSString *aUsername, EMError *aError) {
            if (!aError) {
                NSLog(@"%@",aUsername);
                //下次自动登陆
                [[EMClient sharedClient].options setIsAutoLogin:YES];
            }else{
                NSLog(@"%@",aError);
            }
        }];
    }
    
    //监听在线消息
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
}

- (void)messagesDidReceive:(NSArray *)aMessages {
    for (EMMessage *msg in aMessages) {
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        // App在后台
        if (state == UIApplicationStateBackground) {
            //发送本地推送
            if (NSClassFromString(@"UNUserNotificationCenter")) { // ios 10
                // 设置触发时间
                UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.01 repeats:NO];
                UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
                content.sound = [UNNotificationSound defaultSound];
                // 提醒，可以根据需要进行弹出，比如显示消息详情，或者是显示“您有一条新消息”
                content.body = @"您有一条新消息";
                UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:msg.messageId content:content trigger:trigger];
                [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
            }else {
                UILocalNotification *notification = [[UILocalNotification alloc] init];
                notification.fireDate = [NSDate date]; //触发通知的时间
                notification.alertBody = @"提醒内容";
                notification.alertAction = @"Open";
                notification.timeZone = [NSTimeZone defaultTimeZone];
                notification.soundName = UILocalNotificationDefaultSoundName;
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            }
        }else{
            NSLog(@"SFHDJFKDGFLHJHGSAHDGJF");
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshMyMessage" object:nil];
        }
    }
}

#pragma mark - <注册第三方平台>
-(void)registerApp
{
    [WXApi registerApp:kWeChatAppID];
    [WeiboSDK registerApp:kSinaAppKey];
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
                                  [appInfo SSDKSetupSinaWeiboByAppKey:kSinaAppKey
                                                            appSecret:kSinaAppSecret
                                                          redirectUri:kSinaWeiboCallBack
                                                             authType:SSDKAuthTypeSSO];
                                  break;
                              case SSDKPlatformTypeWechat:
                                  [appInfo SSDKSetupWeChatByAppId:kWeChatAppID
                                                        appSecret:kWeChatAppSecret];
                                  break;
                              case SSDKPlatformTypeQQ:
                                  [appInfo SSDKSetupQQByAppId:kQQAppID
                                                       appKey:kQQAppSecret
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

#pragma mark - <注册了推送功能，会回调以下两个方法，得到deviceToken，需要将deviceToken传给SDK>
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient]bindDeviceToken:deviceToken];
    });
    
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"IM_Push_error:--%@--",error);
}

-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[EMClient sharedClient]applicationDidEnterBackground:application];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[EMClient sharedClient] applicationWillEnterForeground:application];
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
