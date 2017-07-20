//
//  ModifyPasswordViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/20.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "ModifyPasswordViewController.h"

@interface ModifyPasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *tfInputPassword;
@property (weak, nonatomic) IBOutlet UITextField *tfInputPasswordAgain;
@property (weak, nonatomic) IBOutlet UIButton *btnConfirm;

@end

@implementation ModifyPasswordViewController

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


#pragma mark - <配置outlets>
-(void)settingOutlets
{
    //设置左图textfiled
    
}


- (IBAction)btnConfirmModifyAction:(UIButton *)sender
{
    
}









@end
