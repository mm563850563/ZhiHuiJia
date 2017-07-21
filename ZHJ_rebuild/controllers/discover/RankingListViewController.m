//
//  RankingListViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/20.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "RankingListViewController.h"

//cells
#import "ActivityRankFirstCell.h"
#import "ActivityRankNormalCell.h"

@interface RankingListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RankingListViewController

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
    
    UINib *nibNormal = [UINib nibWithNibName:NSStringFromClass([ActivityRankNormalCell class]) bundle:nil];
    [self.tableView registerNib:nibNormal forCellReuseIdentifier:NSStringFromClass([ActivityRankNormalCell class])];
}









#pragma mark - *** UITableViewDelegate,UITableViewDataSource ****
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 2;
//}

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
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (indexPath.row == 0) {
        ActivityRankFirstCell *cellFirst = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ActivityRankFirstCell class])];
        cellFirst.labelTitle.text = @"圈子活跃度规则及奖励说明";
        cell = cellFirst;
        
    }else{
        ActivityRankNormalCell *cellNormal = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ActivityRankNormalCell class])];
        cell = cellNormal;
    }
    return cell;
}







@end
