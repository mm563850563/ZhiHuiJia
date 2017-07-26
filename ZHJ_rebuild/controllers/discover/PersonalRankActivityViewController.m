//
//  PersonalRankActivityViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/21.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "PersonalRankActivityViewController.h"

//cells
#import "ActivityRankFirstCell.h"
#import "PersonalActivityRankCell.h"

//views
#import "PersonalActivityRankFooterView.h"

//controllers
#import "FocusPersonFileViewController.h"
#import "PersonalActivitilyRuleViewController.h"

@interface PersonalRankActivityViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PersonalRankActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self settingTableView];
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
    
    UINib *nibFirst = [UINib nibWithNibName:NSStringFromClass([ActivityRankFirstCell class]) bundle:nil];
    [self.tableView registerNib:nibFirst forCellReuseIdentifier:NSStringFromClass([ActivityRankFirstCell class])];
    
    UINib *nibNormal = [UINib nibWithNibName:NSStringFromClass([PersonalActivityRankCell class]) bundle:nil];
    [self.tableView registerNib:nibNormal forCellReuseIdentifier:NSStringFromClass([PersonalActivityRankCell class])];
}

#pragma mark - <跳转“活跃度规则”页面>
-(void)jumpToPersonalActivitilyRuleVC
{
    PersonalActivitilyRuleViewController *personalActivitilyRuleVC = [[PersonalActivitilyRuleViewController alloc]initWithNibName:NSStringFromClass([PersonalActivitilyRuleViewController class]) bundle:nil];
    personalActivitilyRuleVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personalActivitilyRuleVC animated:YES];
}










#pragma mark - *** UITableViewDelegate,UITableViewDataSource ****

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 60;
    }
    return 70;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([PersonalActivityRankFooterView class]) owner:nil options:nil].lastObject;
    return footerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (indexPath.row == 0) {
        ActivityRankFirstCell *cellFirst = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ActivityRankFirstCell class])];
        cellFirst.labelTitle.text = @"个人活跃度规则及奖励说明";
        cell = cellFirst;
        
    }else{
        PersonalActivityRankCell *cellNormal = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PersonalActivityRankCell class])];
        cell = cellNormal;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self jumpToPersonalActivitilyRuleVC];
    }else{
        FocusPersonFileViewController *focusPersonFileVC = [[FocusPersonFileViewController alloc]initWithNibName:NSStringFromClass([FocusPersonFileViewController class]) bundle:nil];
        [self.navigationController pushViewController:focusPersonFileVC animated:YES];
    }
    
}

@end
