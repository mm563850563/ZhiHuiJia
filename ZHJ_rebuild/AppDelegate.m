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
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "WXApiManager.h"
#import "SearchNetTool.h"
#import <AFNetworkReachabilityManager.h>

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
    
    //***************全局键盘自动管理*************
    [self settingIQKeyBoardManager];
    
    //**************支持摇一摇******************
    [self settingShake];
    
    [self settingMainTabbarVC];
    
    //****************登陆***************
    [self presentLogionVC];
    
    //****************微信支付*****************
    [WXApi registerApp:kWeChatPay_AppID ];
    
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

#pragma mark - <AliPaySDK>
// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    return YES;
}

#pragma mark - <微信支付>

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    // 跳转到URL scheme中配置的地址
    //NSLog(@"跳转到URL scheme中配置的地址-->%@",url);
    /*! @brief 处理微信通过URL启动App时传递的数据
     *
     * 需要在 application:openURL:sourceApplication:annotation:或者application:handleOpenURL中调用。
     * @param url 微信启动第三方应用时传递过来的URL
     * @param delegate  WXApiDelegate对象，用来接收微信触发的消息。
     * @return 成功返回YES，失败返回NO。
     */
    return [WXApi handleOpenURL:url delegate:self];
}

//支付成功时调用，回到第三方应用中
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    /*! @brief 处理微信通过URL启动App时传递的数据
     *
     * 需要在 application:openURL:sourceApplication:annotation:或者application:handleOpenURL中调用。
     * @param url 微信启动第三方应用时传递过来的URL
     * @param delegate  WXApiDelegate对象，用来接收微信触发的消息。
     * @return 成功返回YES，失败返回NO。
     */
    return [WXApi handleOpenURL:url delegate:self];
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
            case WXErrCodeCommon:
            { //签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等
                NSLog(@"支付失败");
            }
                break;
            case WXErrCodeUserCancel:
            { //用户点击取消并返回
                NSLog(@"取消支付");
//                [MBProgressHUD showError:@"取消支付"];
            }
                break;
            case WXErrCodeSentFail:
            { //发送失败
                NSLog(@"发送失败");
//                [MBProgressHUD showError:@"发送失败"];
            }
                break;
            case WXErrCodeUnsupport:
            { //微信不支持
                NSLog(@"微信不支持");
//                [MBProgressHUD showError:@"微信不支持"];
            }
                break;
            case WXErrCodeAuthDeny:
            { //授权失败
                NSLog(@"授权失败");
//                [MBProgressHUD showError:@"授权失败"];
            }
                break;
            default:
                break;
        }
    }
}


@end
