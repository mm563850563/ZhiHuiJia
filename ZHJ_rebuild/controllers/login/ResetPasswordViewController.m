//
//  ResetPasswordViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/11.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "ResetPasswordViewController.h"

#import "NSString+MD5.h"

@interface ResetPasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *tfPhone;
@property (weak, nonatomic) IBOutlet UITextField *tfNewPassword;
@property (weak, nonatomic) IBOutlet UITextField *tfNewPasswordAgain;

@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

#pragma mark - <重置密码>
-(void)resetPassword
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kResetPassword];
    //md5加密
    NSString *password = [kSalt stringByAppendingString:self.tfNewPassword.text];
    password = [NSString md5WithInputText:password];
    
    NSDictionary *dictParameter = @{@"mobile":self.tfPhone.text,
                                    @"verify_code":self.verify_code,
                                    @"password":password};
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:1.0];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:1.0];
                    hudWarning.completionBlock = ^{
                        [self dismissViewControllerAnimated:YES completion:nil];
                    };
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                [hudWarning hideAnimated:YES afterDelay:1.0];
            });
        }
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:1.0];
        });
    }];
}


#pragma mark - <返回按钮响应>
- (IBAction)btnBackAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)btnResetPasswordAction:(UIButton *)sender
{
    if ([self.tfPhone.text isEqualToString:@""]) {
        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"请输入手机号码"];
        [hudWarning hideAnimated:YES afterDelay:1.0];
    }else if ([self.tfNewPassword.text isEqualToString:@""]){
        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"请输入新密码"];
        [hudWarning hideAnimated:YES afterDelay:1.0];
    }else if ([self.tfNewPasswordAgain.text isEqualToString:@""]){
        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"请再次输入新密码"];
        [hudWarning hideAnimated:YES afterDelay:1.0];
    }else if (![self.tfNewPassword.text isEqualToString:self.tfNewPasswordAgain.text]){
        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"两次密码不一致"];
        [hudWarning hideAnimated:YES afterDelay:1.0];
    }else{
        //重置密码
        [self resetPassword];
    }
}













@end
