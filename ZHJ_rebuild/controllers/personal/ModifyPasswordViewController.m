//
//  ModifyPasswordViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/20.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "ModifyPasswordViewController.h"


#import "LoginViewController.h"

#import "NSString+MD5.h"

@interface ModifyPasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *tfOriginPassword;
@property (weak, nonatomic) IBOutlet UITextField *tfInputPassword;
@property (weak, nonatomic) IBOutlet UITextField *tfInputPasswordAgain;
@property (weak, nonatomic) IBOutlet UIButton *btnConfirm;

@end

@implementation ModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

//-(void)viewWillDisappear:(BOOL)animated
//{
//    self.navigationController.navigationBar.hidden = NO;
//}


#pragma mark - <修改密码请求>
-(void)requestModifyPassword
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kUpdatePassword];
    
    if (kUserDefaultObject(kUserInfo)) {
        NSString *userID = kUserDefaultObject(kUserInfo);
        NSString *oldPassword = [kSalt stringByAppendingString:self.tfOriginPassword.text];
        oldPassword = [NSString md5WithInputText:oldPassword];
        NSString *newPassword = [kSalt stringByAppendingString:self.tfInputPassword.text];
        newPassword = [NSString md5WithInputText:newPassword];
        NSDictionary *dictParameter = @{@"user_id":userID,
                                        @"old_password":oldPassword,
                                        @"new_password":newPassword};
        
        MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
        [YQNetworking postWithUrl:urlStr refreshRequest:NO cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
            if (response) {
                NSDictionary *dataDict = (NSDictionary *)response;
                NSNumber *code = (NSNumber *)dataDict[@"code"];
                
                if ([code isEqual:@200]) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [hud hideAnimated:YES afterDelay:1.0];
                        hud.completionBlock = ^{
                            [self login];
                        };
                    });
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
}

#pragma mark - <退出登录>
-(void)login
{
    LoginViewController *loginVC = [[LoginViewController alloc]initWithNibName:NSStringFromClass([LoginViewController class]) bundle:nil];
    [self presentViewController:loginVC animated:YES completion:^{
        [self.navigationController popToRootViewControllerAnimated:NO];
        //回到首页
        self.tabBarController.selectedIndex = 0;
    }];
}


#pragma mark - <配置outlets>
-(void)settingOutlets
{
    //设置左图textfiled
    
}

- (IBAction)btnBackAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnConfirmModifyAction:(UIButton *)sender
{
    //修改密码请求
    if ([self.tfOriginPassword.text isEqualToString:@""]) {
        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"请输入旧密码"];
        [hudWarning hideAnimated:YES afterDelay:1.0];
    }else if([self.tfInputPassword.text isEqualToString:@""]){
        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"请输入新密码"];
        [hudWarning hideAnimated:YES afterDelay:1.0];
    }else if([self.tfInputPasswordAgain.text isEqualToString:@""]){
        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"请再次输入新密码"];
        [hudWarning hideAnimated:YES afterDelay:1.0];
    }else{
        if ([self.tfInputPasswordAgain.text isEqualToString:self.tfInputPassword.text]) {
            [self requestModifyPassword];
        }else{
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"新密码不一致"];
            [hudWarning hideAnimated:YES afterDelay:1.0];
        }
        
    }
}









@end
