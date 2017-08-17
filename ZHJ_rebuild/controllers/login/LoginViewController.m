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

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *tfPhone;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForScrollView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self settingHeightForScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - <计算页面高度>
-(void)settingHeightForScrollView
{
    if (kSCREENH_HEIGHT > self.heightForScrollView.constant) {
        self.heightForScrollView.constant = kSCREENH_HEIGHT;
    }
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
        [hud hideAnimated:YES afterDelay:1.0];
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = dataDict[@"code"];
            if ([code isEqual:@200]) {
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                hudWarning.completionBlock = ^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                };
                [hudWarning hideAnimated:YES afterDelay:2.0];
                
                //登陆成功后，把user_id保存本地，用作持久化登陆
                kUserDefaultSetObject(dataDict[@"data"][@"result"][@"user_id"], kUserInfo);
                kUserDefaultSynchronize;
            }else{
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                [hudWarning hideAnimated:YES afterDelay:2.0];
            }
        }
    } failBlock:^(NSError *error) {
        
        [hud hideAnimated:YES afterDelay:1.0];
        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
        [hudWarning hideAnimated:YES afterDelay:2.0];
    }];
}

#pragma mark - <登陆按钮响应>
- (IBAction)btnLoginAction:(UIButton *)sender
{
    if ([self.tfPhone.text isEqualToString:@""]) {
        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:nil];
        hudWarning.label.text = @"请输入手机号码";
        [hudWarning hideAnimated:YES afterDelay:2.0];
    }else if ([self.tfPassword.text isEqualToString:@""]){
        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:nil];
        hudWarning.label.text = @"请输入密码";
        [hudWarning hideAnimated:YES afterDelay:2.0];
    }else{
        [self postLoginRequest];
    }
}

#pragma mark - <立即注册按钮响应>
- (IBAction)btnRegisterAction:(UIButton *)sender
{
    
}

#pragma mark - <忘记密码按钮响应>
- (IBAction)btnForgetPassword:(UIButton *)sender
{
    
}

#pragma mark - <qq登陆按钮响应>
- (IBAction)btnQQLoginAction:(UIButton *)sender
{
    
}

#pragma mark - <微信登陆按钮响应>
- (IBAction)btnWechatLoginAction:(UIButton *)sender
{
    
}

#pragma mark - <微博登陆按钮响应>
- (IBAction)btnWeiboLoginAction:(UIButton *)sender
{
    
}














@end
