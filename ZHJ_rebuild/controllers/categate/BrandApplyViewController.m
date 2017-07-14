//
//  BrandApplyViewController.m
//  ZHJ_rebuild
//
//  Created by sophia on 2017/7/11.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "BrandApplyViewController.h"

@interface BrandApplyViewController ()

//heights
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForView1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForView2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForView3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForSubmitBtn;

@end

@implementation BrandApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    CGFloat height = self.heightForView1.constant + self.heightForView2.constant + self.heightForView3.constant + self.heightForSubmitBtn.constant;
    if (height>self.view.frame.size.height) {
        self.heightForScrollView.constant = self.view.frame.size.height;
    }else{
        self.heightForScrollView.constant = height;
    }
}

@end
