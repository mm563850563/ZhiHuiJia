//
//  HotCircleViewController.m
//  ZHJ_rebuild
//
//  Created by ZHJ on 2017/7/20.
//  Copyright © 2017年 sophia. All rights reserved.
//

#import "HotCircleViewController.h"

//cells
#import "HotCircleCell.h"

@interface HotCircleViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HotCircleViewController

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

#pragma mark - <配置tableView>
-(void)settingTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = kColorFromRGB(kLightGray);
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([HotCircleCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:NSStringFromClass([HotCircleCell class])];
}










#pragma mark - *** UITableViewDelegate,UITableViewDataSource ****
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 5) {
        return 100;
    }
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, kSCREEN_WIDTH, 35)];
    headerView.backgroundColor = kColorFromRGB(kWhite);
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, headerView.frame.size.width/2, headerView.frame.size.height)];
    label1.text = @"王者荣绕";
    label1.font = [UIFont systemFontOfSize:13];
    [headerView addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(headerView.frame.size.width-60, 0, 50, headerView.frame.size.height)];
    label2.text = @"更多>";
    label2.font = [UIFont systemFontOfSize:13];
    [headerView addSubview:label2];
    
    return headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HotCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HotCircleCell class])];
    return cell;
}



@end
