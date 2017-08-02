//
//  LoginView.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/8/2.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "LoginView.h"

@interface LoginView ()

@property (weak, nonatomic) IBOutlet UITextField *tfPhone;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForScrollView;

@end

@implementation LoginView

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
    
    [self settingHeightForScrollView];
}

#pragma mark - <计算页面高度>
-(void)settingHeightForScrollView
{
    if (kSCREENH_HEIGHT > self.heightForScrollView.constant) {
        self.heightForScrollView.constant = kSCREENH_HEIGHT;
    }
}

#pragma mark - <登陆按钮响应>
- (IBAction)btnLoginAction:(UIButton *)sender
{
    
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
