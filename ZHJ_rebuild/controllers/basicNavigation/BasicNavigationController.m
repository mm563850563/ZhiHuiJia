//
//  BasicNavigationController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/3.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "BasicNavigationController.h"

@interface BasicNavigationController ()

@end

@implementation BasicNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar setBarTintColor:kColorFromRGB(kThemeYellow)];
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

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        
        
        UIImage *backIcon = [UIImage imageNamed:@"back"];
        backIcon = [backIcon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIButton *btnBack  = [UIButton buttonWithType:UIButtonTypeCustom];
        btnBack.frame = CGRectMake(0, 0, 20, 20);
        [btnBack setImage:backIcon forState:UIControlStateNormal];
        [btnBack addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]initWithCustomView:btnBack];
        viewController.navigationItem.leftBarButtonItem = buttonItem;
    }
//    self.navigationBarHidden = NO;
    [super pushViewController:viewController animated:animated];
    
    
    
//    if (self.childViewControllers.count > 0) { // 如果push进来的不是第一个控制器
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button setTitle:@"返回" forState:UIControlStateNormal];
//        [button setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
//        [button setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
//        button.size = CGSizeMake(70, 30);
//        // 让按钮内部的所有内容左对齐
//        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        //        [button sizeToFit];
//        // 让按钮的内容往左边偏移10
//        button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
//        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
//        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//        // 隐藏tabbar
//        viewController.hidesBottomBarWhenPushed = YES;
//    }
//    
//    // 这句super的push要放在后面, 让viewController可以覆盖上面设置的leftBarButtonItem
//    [super pushViewController:viewController animated:animated];
}

-(void)backAction
{
    [self popViewControllerAnimated:YES];
}

@end
