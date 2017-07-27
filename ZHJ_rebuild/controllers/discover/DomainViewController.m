//
//  DomainViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/21.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "DomainViewController.h"

//cells
#import "FocusPersonCell.h"

//views
#import "DomainHeaderView.h"

//controllers
#import "NotificationViewController.h"
#import "PersonalFileViewController.h"
#import "MyFocusViewController.h"
#import "ActivityViewController.h"
#import "PersonalRankActivityViewController.h"
#import "NewPostViewController.h"

@interface DomainViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DomainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self settingTableView];
    [self respondWithRAC];
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


-(void)settingTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UINib *nibDynamic = [UINib nibWithNibName:NSStringFromClass([FocusPersonCell class]) bundle:nil];
    [self.tableView registerNib:nibDynamic forCellReuseIdentifier:NSStringFromClass([FocusPersonCell class])];
}

#pragma mark - <跳转“我的关注”页面>
-(void)jumpToMyOnFocusVC
{
    MyFocusViewController *myFocusVC = [[MyFocusViewController alloc]initWithNibName:NSStringFromClass([MyFocusViewController class]) bundle:nil];
    [self.navigationController pushViewController:myFocusVC animated:YES];
}

#pragma mark - <跳转“消息通知”页面>
-(void)jumpToMessageVC
{
    NotificationViewController *notificationVC = [[NotificationViewController alloc]init];
    [self.navigationController pushViewController:notificationVC animated:YES];
}

#pragma mark - <跳转“个人资料”页面>
-(void)jumpToPersonalFileVC
{
    PersonalFileViewController *personalFileVC = [[PersonalFileViewController alloc]init];
    [self.navigationController pushViewController:personalFileVC animated:YES];
}

#pragma mark - <跳转“我的活动”页面>
-(void)jumpToMyActivitiesVC
{
    ActivityViewController *activityVC = [[ActivityViewController alloc]initWithNibName:NSStringFromClass([ActivityViewController class]) bundle:nil];
    [self.navigationController pushViewController:activityVC animated:YES];
}

#pragma mark - <跳转“参与的活动”页面>
#pragma mark - <跳转“个人活跃度排名”页面>
-(void)jumpToPersonalRankVC
{
    PersonalRankActivityViewController *personalRankVC = [[PersonalRankActivityViewController alloc]initWithNibName:NSStringFromClass([PersonalRankActivityViewController class]) bundle:nil];
    [self.navigationController pushViewController:personalRankVC animated:YES];
}

#pragma mark - <跳转发布新帖子页面>
-(void)jumpToReleaseNewPostVC
{
    NewPostViewController *newPostVC = [[NewPostViewController alloc]initWithNibName:NSStringFromClass([NewPostViewController class]) bundle:nil];
    newPostVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newPostVC animated:YES];
}

#pragma mark - <RAC响应>
-(void)respondWithRAC
{
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"backToDiscover" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"DomainToMessage" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        [self jumpToMessageVC];
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"DomainToEdit" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        [self jumpToPersonalFileVC];
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"DomainToMyFocus" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        [self jumpToMyOnFocusVC];
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"DomainToMyFans" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        [self jumpToMyOnFocusVC];
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"DomainToMyActivities" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        [self jumpToMyActivitiesVC];
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"DomainToJoinedActivities" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        [self jumpToMyActivitiesVC];
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"DomainToRankActivity" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        [self jumpToPersonalRankVC];
    }];
    
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"DomainToRelease" object:nil]subscribeNext:^(NSNotification * _Nullable x) {
        [self jumpToReleaseNewPostVC];
    }];
}










#pragma mark - *** UITableViewDelegate,UITableViewDataSource ****
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 340;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([DomainHeaderView class]) owner:nil options:nil].lastObject;
    return headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FocusPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FocusPersonCell class])];
    return cell;
}



@end
