//
//  CategateNavigationController.m
//  ZHJ_rebuild
//
//  Created by sophia on 2017/7/11.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "CategateNavigationController.h"

@interface CategateNavigationController ()

@end

@implementation CategateNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingNavigation];
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

-(void)settingNavigation
{
    self.navigationBar.translucent = NO;
}

@end
