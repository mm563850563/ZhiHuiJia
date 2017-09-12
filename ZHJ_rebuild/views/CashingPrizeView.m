//
//  CashingPrizeView.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/11.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "CashingPrizeView.h"

@interface CashingPrizeView ()

@property (weak, nonatomic) IBOutlet UITextField *tfPhone;
@property (weak, nonatomic) IBOutlet UITextField *tfVerfiCode;
@property (weak, nonatomic) IBOutlet UIButton *btnVerfiCode;
@property (weak, nonatomic) IBOutlet UITextField *tfCountryNumber;


@end

@implementation CashingPrizeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [self settingOutlets];
}


#pragma mark - <获取验证码按钮响应>
- (IBAction)btnVerfiCodeAction:(UIButton *)sender
{
    if (![self.tfPhone.text isEqualToString:@""]) {
        //开启验证码倒计时
        [self openBtnVerificationCountDowm];
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"getVerifyCodeFromCashingView" object:self.tfPhone.text];
    
}

#pragma mark - <确认领取按钮响应>
- (IBAction)btnCashingAction:(UIButton *)sender
{
    NSString *user_id = kUserDefaultObject(kUserInfo);
    if (![self.tfPhone.text isEqualToString:@""] && ![self.tfVerfiCode.text isEqualToString:@""]) {
        NSDictionary *dictParameter = @{@"user_id":user_id,
                                        @"verify_code":self.tfVerfiCode.text,
                                        @"mobile":self.tfPhone.text};
        [[NSNotificationCenter defaultCenter]postNotificationName:@"confirmGetPrizeFromCashingView" object:dictParameter];
    }
    
}

#pragma mark - <配置outlets>
-(void)settingOutlets
{
    self.tfCountryNumber.enabled = NO;
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
                [self.btnVerfiCode setTitle:@"获取验证码" forState:UIControlStateNormal];
                [self.btnVerfiCode setTitleColor:kColorFromRGB(kBlack) forState:UIControlStateNormal];
                self.btnVerfiCode.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [self.btnVerfiCode setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
                [self.btnVerfiCode setTitleColor:kColorFromRGB(kDeepGray) forState:UIControlStateNormal];
                self.btnVerfiCode.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}





@end
