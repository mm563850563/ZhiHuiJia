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
    [self.navigationController pushViewController:disclaimerVC animated:YES];
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
