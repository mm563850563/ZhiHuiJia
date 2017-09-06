//
//  ForgetPasswordViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/6.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "ForgetPasswordViewController.h"

@interface ForgetPasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *tfPhone;
@property (weak, nonatomic) IBOutlet UITextField *tfCode;
@property (weak, nonatomic) IBOutlet UIButton *btnGetCode;

@property (nonatomic, strong)NSString *verificationCode;

@end

@implementation ForgetPasswordViewController

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


#pragma mark - <获取忘记密码短信>
-(void)getForgetPasswordMessageData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kForgetPassword];
    NSDictionary *dictParameter = @{@"mobile":self.tfPhone.text};
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                dispatch_async(dispatch_get_main_queue(), ^{
//                    self.verificationCode = 
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:2.0];
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
                [hudWarning hideAnimated:YES afterDelay:2.0];
            });
        }
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:2.0];
        });
    }];
}

#pragma mark - <验证码按钮倒计时效果>
-(void)openBtnVerificationCountDowm
{
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [self.btnGetCode setTitle:@"获取验证码" forState:UIControlStateNormal];
                [self.btnGetCode setTitleColor:kColorFromRGB(kBlack) forState:UIControlStateNormal];
                self.btnGetCode.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [self.btnGetCode setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
                [self.btnGetCode setTitleColor:kColorFromRGB(kDeepGray) forState:UIControlStateNormal];
                self.btnGetCode.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - <获取验证码响应>
- (IBAction)btnGetCodeAction:(UIButton *)sender
{
    if ([self.tfPhone.text isEqualToString:@""]) {
        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"请输入手机号码"];
        [hudWarning hideAnimated:YES afterDelay:2.0];
    }else{
        //开启验证码倒计时
        [self openBtnVerificationCountDowm];
        
        [self getForgetPasswordMessageData];
    }
}

#pragma mark - <下一步>
- (IBAction)btnNextStepAction:(UIButton *)sender
{
    
}

#pragma mark - <返回按钮>
- (IBAction)btnBackAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
















@end
