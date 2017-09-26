//
//  FeedbackViewController.m
//  ZhiHuiJia
//
//  Created by sophia on 17/7/6.
//  Copyright (c) 2017年 sophia. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *feedbackView;
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeholder;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.feedbackView.delegate = self;
    self.placeholder.userInteractionEnabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)loadView
//{
//    [super loadView];
//    [self.navigationController setNavigationBarHidden:NO];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - <提交意见反馈>
-(void)requestFeedback
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kDomainBase,kReportCenter];
    
    if (kUserDefaultObject(kUserInfo)) {
        NSString *userID = kUserDefaultObject(kUserInfo);
        NSDictionary *dictParameter = @{@"user_id":userID,
                                        @"type":@"0",
                                        @"content":self.feedbackView.text};
        
        MBProgressHUD *hud = [ProgressHUDManager showProgressHUDAddTo:self.view animated:YES];
        [YQNetworking postWithUrl:urlStr refreshRequest:NO cache:NO params:dictParameter progressBlock:nil successBlock:^(id response) {
            if (response) {
                NSDictionary *dataDict = (NSDictionary *)response;
                NSNumber *code = (NSNumber *)dataDict[@"code"];
                
                if ([code isEqual:@200]) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [hud hideAnimated:YES afterDelay:1.0];
                        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:dataDict[@"msg"]];
                        [hudWarning hideAnimated:YES afterDelay:1.0];
                        hudWarning.completionBlock = ^{
                            [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)btnSubmitAction:(UIButton *)sender
{
    if ([self.feedbackView.text isEqualToString:@""]) {
        MBProgressHUD *hudWarning = [ProgressHUDManager showWarningProgressHUDAddTo:self.view animated:YES warningMessage:@"请输入反馈意见"];
        [hudWarning hideAnimated:YES afterDelay:1.0];
    }else{
        [self requestFeedback];
    }
    
}







#pragma mark - ***** UITextViewDelegate ******
- (void)textViewDidChange:(UITextView *)textView
{
    self.placeholder.hidden = YES;
    //允许提交按钮点击操作
//    self.commitButton.backgroundColor = FDMainColor;
//    self.commitButton.userInteractionEnabled = YES;
    //实时显示字数
    self.limitLabel.text = [NSString stringWithFormat:@"%lu/300", (unsigned long)textView.text.length];
    
    //字数限制操作
    if (textView.text.length >= 300) {
        
        textView.text = [textView.text substringToIndex:300];
        self.limitLabel.text = @"300/300";
        
    }
    //取消按钮点击权限，并显示提示文字
    if (textView.text.length == 0) {
        
        self.placeholder.hidden = NO;
//        self.commitButton.userInteractionEnabled = NO;
//        self.commitButton.backgroundColor = [UIColor lightGrayColor];
        
    }
    
}

@end
