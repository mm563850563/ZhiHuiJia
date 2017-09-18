//
//  LoginViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/2.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "LoginViewController.h"

//models

//tools
#import "NSString+MD5.h"

//controllers
#import "RegisterViewController.h"
#import "ForgetPasswordViewController.h"
#import "SelectThemeAndClassifyViewController.h"
#import "MainTabBarViewController.h"

//SDKs
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "WeiboSDK.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *tfPhone;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForScrollView;
@property (weak, nonatomic) IBOutlet UIView *thirdLoginBGView;
@property (weak, nonatomic) IBOutlet UIButton *btnWeiboLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnWeixinLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnQQLogin;

@property (nonatomic, strong)NSMutableArray *currentThirdAppArray;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self checkCurrentThirdApp];
    [self settingHeightForScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <懒加载>
-(NSMutableArray *)currentThirdAppArray
{
    if (!_currentThirdAppArray) {
        _currentThirdAppArray = [NSMutableArray array];
    }
    return _currentThirdAppArray;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - <用户是否已登陆>
-(void)checkUserIsLogined
{
    if (!kUserDefaultObject(kUserInfo)) {
        NSLog(@"--------%@-------",kUserDefaultObject(kUserInfo));
        
    }else{
        NSLog(@"--------%@-------",kUserDefaultObject(kUserInfo));
        [self presentMainTabVC];
    }
}

#pragma mark - <检测是否安装“qq”，“微信”，“新浪”>
-(void)checkCurrentThirdApp
{
    
    if ([QQApiInterface isQQInstalled]) {
        [self.currentThirdAppArray addObject:@"qq"];
    }
    if ([WXApi isWXAppInstalled]){
        [self.currentThirdAppArray addObject:@"weixin"];
    }
    if ([WeiboSDK isWeiboAppInstalled]){
        [self.currentThirdAppArray addObject:@"weibo"];
    }
    
    //显示已安装的appIcon
    [self displayInstalledAppIcon];
}

#pragma mark - <根据用户安装的第三方app显示>
-(void)displayInstalledAppIcon
{
    __weak typeof(self) weakSelf = self;
    switch ((int)self.currentThirdAppArray.count) {
        case 0:
            [self.btnQQLogin setHidden:YES];
            [self.btnWeiboLogin setHidden:YES];
            [self.btnWeixinLogin setHidden:YES];
            break;
            
        case 1:
            for (NSString *temp in self.currentThirdAppArray) {
                if ([temp isEqualToString:@"qq"]) {
                    [self.btnQQLogin setHidden:NO];
                    [self.btnWeiboLogin setHidden:YES];
                    [self.btnWeixinLogin setHidden:YES];
                    
                    [self.btnQQLogin mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_offset(CGSizeMake(50, 50));
                        make.center.mas_equalTo(weakSelf.thirdLoginBGView);
                    }];
                }else if ([temp isEqualToString:@"weixin"]) {
                    [self.btnWeixinLogin setHidden:NO];
                    [self.btnWeiboLogin setHidden:YES];
                    [self.btnQQLogin setHidden:YES];
                    
                    [self.btnWeixinLogin mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_offset(CGSizeMake(50, 50));
                        make.center.mas_equalTo(weakSelf.thirdLoginBGView);
                    }];
                }else if ([temp isEqualToString:@"weibo"]) {
                    [self.btnWeiboLogin setHidden:NO];
                    [self.btnWeixinLogin setHidden:YES];
                    [self.btnQQLogin setHidden:YES];
                    
                    [self.btnWeixinLogin mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_offset(CGSizeMake(50, 50));
                        make.center.mas_equalTo(weakSelf.thirdLoginBGView);
                    }];
                }
            }
            break;
            
        case 2:
            if (![self.currentThirdAppArray containsObject:@"qq"]) {
                [self.btnWeiboLogin setHidden:NO];
                [self.btnWeixinLogin setHidden:NO];
                [self.btnQQLogin setHidden:YES];
                [self.btnWeixinLogin mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_offset(CGSizeMake(50, 50));
                    make.centerY.mas_equalTo(weakSelf.thirdLoginBGView);
                    make.centerX.mas_equalTo(weakSelf.thirdLoginBGView.mas_centerX).with.offset(40);
                }];
                [self.btnWeiboLogin mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_offset(CGSizeMake(50, 50));
                    make.centerY.mas_equalTo(weakSelf.thirdLoginBGView);
                    make.centerX.mas_equalTo(weakSelf.thirdLoginBGView.mas_centerX).with.offset(-40);
                }];
            }else if (![self.currentThirdAppArray containsObject:@"weixin"]) {
                [self.btnWeiboLogin setHidden:NO];
                [self.btnWeixinLogin setHidden:YES];
                [self.btnQQLogin setHidden:NO];
                [self.btnQQLogin mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_offset(CGSizeMake(50, 50));
                    make.centerY.mas_equalTo(weakSelf.thirdLoginBGView);
                    make.centerX.mas_equalTo(weakSelf.thirdLoginBGView.mas_centerX).with.offset(40);
                }];
                [self.btnWeiboLogin mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_offset(CGSizeMake(50, 50));
                    make.centerY.mas_equalTo(weakSelf.thirdLoginBGView);
                    make.centerX.mas_equalTo(weakSelf.thirdLoginBGView.mas_centerX).with.offset(-40);
                }];
            }else if (![self.currentThirdAppArray containsObject:@"weibo"]) {
                [self.btnWeiboLogin setHidden:YES];
                [self.btnWeixinLogin setHidden:NO];
                [self.btnQQLogin setHidden:NO];
                [self.btnQQLogin mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_offset(CGSizeMake(50, 50));
                    make.centerY.mas_equalTo(weakSelf.thirdLoginBGView);
                    make.centerX.mas_equalTo(weakSelf.thirdLoginBGView.mas_centerX).with.offset(40);
                }];
                [self.btnWeixinLogin mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_offset(CGSizeMake(50, 50));
                    make.centerY.mas_equalTo(weakSelf.thirdLoginBGView);
                    make.centerX.mas_equalTo(weakSelf.thirdLoginBGView.mas_centerX).with.offset(-40);
                }];
            }
            break;
            
        case 3:
            [self.btnQQLogin setHidden:NO];
            [self.btnWeiboLogin setHidden:NO];
            [self.btnWeixinLogin setHidden:NO];
            break;
            
        default:
            break;
    }
}

#pragma mark - <计算页面高度>
-(void)settingHeightForScrollView
{
    if (kSCREENH_HEIGHT > self.heightForScrollView.constant) {
        self.heightForScrollView.constant = kSCREENH_HEIGHT;
    }
}

#pragma mark - <模态mainTabVC>
-(void)presentMainTabVC
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainTabBarViewController *mainTabbarVC = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([MainTabBarViewController class])];
    [self presentViewController:mainTabbarVC animated:NO completion:nil];
}

#pragma mark - <发送登陆请求>
-(void)postLoginRequest
{
    NSString *strLogin = [NSString stringWithFormat:@"%@%@",kDomainBase,kLogin];
    //md5加密
    NSString *password = [kSalt stringByAppendingString:self.tfPassword.text];
    password = [NSString md5WithInputText:password];
    NSDictionary *dictParameter = @{@"mobile":self.tfPhone.text,
                                    @"password":password};
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:strLogin refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = dataDict[@"code"];
            if ([code isEqual:@200]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES];
                    //登陆成功后，把user_id保存本地，用作持久化登陆
                    NSString *user_id = [NSString stringWithFormat:@"%@",dataDict[@"data"][@"result"][@"user_id"]];
                    kUserDefaultSetObject(user_id, kUserInfo);
                    kUserDefaultSynchronize;
                    
                    //判断是否已经选择过颜色主题
                    NSNumber *selected_cat = dataDict[@"data"][@"result"][@"selected_cat"];
                    
                    if ([selected_cat isEqual:@0]) {
                        //模态出选择喜欢的品类页面
                        [self presentSelectThemeVC];
                    }else{
                        [self presentMainTabVC];
                    }
                    
                });
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:1.0];
                    [hud hideAnimated:YES afterDelay:1.0];
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:1.0];
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                [hudWarning hideAnimated:YES afterDelay:1.0];
            });
        }
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:1.0];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:1.0];
        });
        
    }];
}

#pragma mark - <第三方登录请求>
-(void)requestThirdLoginWithOauth:(NSString *)oauth openid:(NSString *)openid nickname:(NSString *)nickname headimg:(NSString *)headimg sex:(NSString *)sex unionid:(NSString *)unionid
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kThirdLogin];
    
    NSDictionary *dictParameter = [NSDictionary dictionary];
    if (unionid) {
        dictParameter = @{@"oauth":oauth,
                                        @"openid":openid,
                                        @"nickname":nickname,
                                        @"headimg":headimg,
                                        @"sex":sex,
                                        @"unionid":unionid};
    }else{
        dictParameter = @{@"oauth":oauth,
                                        @"openid":openid,
                                        @"nickname":nickname,
                                        @"headimg":headimg,
                                        @"sex":sex};

    }
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES];
                    //登陆成功后，把user_id保存本地，用作持久化登陆
                    NSString *user_id = [NSString stringWithFormat:@"%@",dataDict[@"data"][@"result"][@"user_id"]];
                    kUserDefaultSetObject(user_id, kUserInfo);
                    kUserDefaultSynchronize;
                    
                    //判断是否已经选择过颜色主题
                    NSNumber *selected_cat = dataDict[@"data"][@"result"][@"selected_cat"];
                    
                    if ([selected_cat isEqual:@0]) {
                        //模态出选择喜欢的品类页面
                        [self presentSelectThemeVC];
                    }else{
                        [self presentMainTabVC];
                    }
                    
                });
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
//                    hudWarning.completionBlock = ^{
//                        
//                        [self dismissViewControllerAnimated:YES completion:nil];
//                    };
//                    [hudWarning hideAnimated:YES afterDelay:1.0];
//                    
//                    //登陆成功后，把user_id保存本地，用作持久化登陆
//                    kUserDefaultSetObject(dataDict[@"data"][@"result"][@"user_id"], kUserInfo);
//                    kUserDefaultSynchronize;
//                    
//                    hudWarning.completionBlock = ^{
//                        NSNumber *selected_cat = dataDict[@"data"][@"result"][@"selected_cat"];
//                        
//                        if ([selected_cat isEqual:@0]) {
//                            //模态出选择喜欢的品类
//                            [self presentSelectThemeVC];
//                        }else{
//                            [self dismissViewControllerAnimated:YES completion:nil];
//                        }
//                        
//                    };
//                    
//                    [hud hideAnimated:YES afterDelay:1.0];
//                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:1.0];
                });
            }
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:1.0];
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestEmptyData];
                [hudWarning hideAnimated:YES afterDelay:1.0];
            });
        }
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:1.0];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:1.0];
        });
    }];
}

#pragma mark - <模态出选择主题页面>
-(void)presentSelectThemeVC
{
    SelectThemeAndClassifyViewController *selectThemeVC = [[SelectThemeAndClassifyViewController alloc]initWithNibName:NSStringFromClass([SelectThemeAndClassifyViewController class]) bundle:nil];
    selectThemeVC.whereReuseFrom = @"loginVC";
    [self presentViewController:selectThemeVC animated:YES completion:nil];
}

#pragma mark - <登陆按钮响应>
- (IBAction)btnLoginAction:(UIButton *)sender
{
    if ([self.tfPhone.text isEqualToString:@""]) {
        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:nil];
        hudWarning.label.text = @"请输入手机号码";
        [hudWarning hideAnimated:YES afterDelay:1.0];
    }else if ([self.tfPassword.text isEqualToString:@""]){
        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:nil];
        hudWarning.label.text = @"请输入密码";
        [hudWarning hideAnimated:YES afterDelay:1.0];
    }else{
        [self postLoginRequest];
    }
}

#pragma mark - <立即注册按钮响应>
- (IBAction)btnRegisterAction:(UIButton *)sender
{
    RegisterViewController *registerVC = [[RegisterViewController alloc]initWithNibName:NSStringFromClass([RegisterViewController class]) bundle:nil];
    [self presentViewController:registerVC animated:YES completion:nil];
}

#pragma mark - <忘记密码按钮响应>
- (IBAction)btnForgetPassword:(UIButton *)sender
{
    ForgetPasswordViewController *forgetPasswordVC = [[ForgetPasswordViewController alloc]initWithNibName:NSStringFromClass([ForgetPasswordViewController class]) bundle:nil];
    [self presentViewController:forgetPasswordVC animated:YES completion:nil];
}

#pragma mark - <qq登陆按钮响应>
- (IBAction)btnQQLoginAction:(UIButton *)sender
{
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [ShareSDK getUserInfo:SSDKPlatformTypeQQ onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        
        if (state == SSDKResponseStateSuccess)
        {
            NSString *oauth = @"qq";
            NSString *nickname = user.nickname;
            
            NSString *sex = [NSString string];
            NSInteger gender = user.gender;
            if (gender == 0) {
                sex = @"1";
            }else{
                sex = @"2";
            }
            
            //uid就是openid
            NSString *openid = user.uid;
            
            NSString *headimg = user.icon;
            
            [self requestThirdLoginWithOauth:oauth openid:openid nickname:nickname headimg:headimg sex:sex unionid:nil];
        }else{
            NSLog(@"%@",error);
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"授权失败,请稍后再试"];
                [hudWarning hideAnimated:YES afterDelay:1.0];
            });
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    }];
}

#pragma mark - <微信登陆按钮响应>
- (IBAction)btnWechatLoginAction:(UIButton *)sender
{
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        if (state == SSDKResponseStateSuccess)
        {
            NSString *oauth = @"weixin";
            NSString *nickname = user.nickname;
            
            NSString *sex = [NSString string];
            NSInteger gender = user.gender;
            if (gender == 0) {
                sex = @"1";
            }else{
                sex = @"2";
            }
            
            //uid就是openid
            NSString *openid = user.uid;
            
            NSString *headimg = user.icon;
            
            [self requestThirdLoginWithOauth:oauth openid:openid nickname:nickname headimg:headimg sex:sex unionid:nil];
            
        }else{
            NSLog(@"%@",error);
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"授权失败,请稍后再试"];
                [hudWarning hideAnimated:YES afterDelay:1.0];
            });
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    }];
}

#pragma mark - <微博登陆按钮响应>
- (IBAction)btnWeiboLoginAction:(UIButton *)sender
{
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        if (state == SSDKResponseStateSuccess)
        {
            NSString *oauth = @"weibo";
            NSString *nickname = user.nickname;
            
            NSString *sex = [NSString string];
            NSInteger gender = user.gender;
            if (gender == 0) {
                sex = @"1";
            }else{
                sex = @"2";
            }
            
            //uid就是openid
            NSString *openid = user.uid;
            
            NSString *headimg = user.icon;
            
            [self requestThirdLoginWithOauth:oauth openid:openid nickname:nickname headimg:headimg sex:sex unionid:nil];
        }else{
            NSLog(@"%@",error);
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"授权失败,请稍后再试"];
                [hudWarning hideAnimated:YES afterDelay:1.0];
            });
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    }];
}














@end
