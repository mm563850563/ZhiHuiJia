//
//  ActivityApplyViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/26.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "ActivityApplyViewController.h"

//controllers
#import "DisclaimerViewController.h"

@interface ActivityApplyViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *applyReasonView;
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeholder;
@property (weak, nonatomic) IBOutlet UIButton *btnDisclaimer;

@end

@implementation ActivityApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingOutlets];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark - <配置outlets>
-(void)settingOutlets
{
    //"同城活动免责声明"按钮
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"同城活动免责声明"];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [self.btnDisclaimer setAttributedTitle:str forState:UIControlStateNormal];
    self.btnDisclaimer.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.btnDisclaimer addTarget:self action:@selector(jumpToDisclaimerVC) forControlEvents:UIControlEventTouchUpInside];
    
    //
    self.applyReasonView.delegate = self;
    self.placeholder.userInteractionEnabled = NO;
}

#pragma mark - <同城活动免责声明响应>
-(void)jumpToDisclaimerVC
{
    DisclaimerViewController *disclaimerVC = [[DisclaimerViewController alloc]initWithNibName:NSStringFromClass([DisclaimerViewController class]) bundle:nil];
    disclaimerVC.disclaimer = self.disclaimer;
    [self.navigationController pushViewController:disclaimerVC animated:YES];
}

#pragma mark - <报名>
-(void)getSignUpActivityData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kSignUpActivity];
    NSDictionary *dictParameter = @{@"user_id":kUserDefaultObject(kUserInfo),
                                    @"activity_id":self.activity_id,
                                    @"reason":self.applyReasonView.text};
    
    MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
    [YQNetworking postWithUrl:urlStr refreshRequest:YES cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
        if (response) {
            NSDictionary *dataDict = (NSDictionary *)response;
            NSNumber *code = (NSNumber *)dataDict[@"code"];
            if ([code isEqual:@200]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"signedForActivity" object:nil];
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:2.0];
                    hudWarning.completionBlock = ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    };
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES afterDelay:1.0];
                    MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                    [hudWarning hideAnimated:YES afterDelay:2.0];
                });
            }
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES afterDelay:1.0];
                MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestEmptyData];
                [hudWarning hideAnimated:YES afterDelay:2.0];
            });
        }
    } failBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES afterDelay:1.0];
            MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:kRequestError];
            [hudWarning hideAnimated:YES afterDelay:2.0];
        });
    }];
}

#pragma mark - <提交按钮响应>
- (IBAction)btnSubmitAction:(UIButton *)sender
{
    [self.view endEditing:YES];
    if ([self.applyReasonView.text isEqualToString:@""]) {
        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"请填写报名理由"];
        [hudWarning hideAnimated:YES afterDelay:2.0];
    }else{
        [self getSignUpActivityData];
    }
}














- (void)textViewDidChange:(UITextView *)textView
{
    //    FDLog(@"%@", textView.text);
    
    self.placeholder.hidden = YES;
    //允许提交按钮点击操作
    //    self.commitButton.backgroundColor = FDMainColor;
    //    self.commitButton.userInteractionEnabled = YES;
    //实时显示字数
    self.limitLabel.text = [NSString stringWithFormat:@"%lu/30", (unsigned long)textView.text.length];
    
    //字数限制操作
    if (textView.text.length >= 30) {
        
        textView.text = [textView.text substringToIndex:30];
        self.limitLabel.text = @"30/30";
        
    }
    //取消按钮点击权限，并显示提示文字
    if (textView.text.length == 0) {
        
        self.placeholder.hidden = NO;
        //        self.commitButton.userInteractionEnabled = NO;
        //        self.commitButton.backgroundColor = [UIColor lightGrayColor];
        
    }
    
}



@end
