//
//  ZHJMessageViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/9/20.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "ZHJMessageViewController.h"

@interface ZHJMessageViewController ()<EaseMessageViewControllerDelegate,EaseMessageViewControllerDataSource>

@end

@implementation ZHJMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self removeMoreViewItem];
    [self settingFunction];
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

#pragma mark - <删除“位置”，“语音”，“视频”>
-(void)removeMoreViewItem
{
    [self.chatBarMoreView removeItematIndex:1];
    [self.chatBarMoreView removeItematIndex:2];
    [self.chatBarMoreView removeItematIndex:2];
}

#pragma mark - <开启下拉刷新>
-(void)settingFunction
{
    self.showRefreshHeader = YES;
//    self.showTableBlankView = YES;
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshConversationList" object:nil];
}















@end
